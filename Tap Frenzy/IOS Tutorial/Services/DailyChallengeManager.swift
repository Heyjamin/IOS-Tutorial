//
//  DailyChallengeManager.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import Foundation
import Combine

@MainActor
final class DailyChallengeManager: ObservableObject {
    
    static let shared = DailyChallengeManager()
    
    @Published private(set) var records: [GameMode: GameDailyChallenge] = [:]
    @Published private(set) var currentDayKey: String = ""
    @Published private(set) var masterStreak: Int = 0
    
    private let storageKey = Const.txtStorageKey
    private let calendar = Calendar.current
    
    private init() {
        loadStore()
        refreshForToday()
    }
    
    func refreshForToday() {
        let today = Self.dayKey(for: Date(), calendar: calendar)
        
        guard today != currentDayKey else { return }
        
        if !currentDayKey.isEmpty {
            handleDayTransition(from: currentDayKey, to: today)
        }else {
            bootstrapRecords(for: today)
        }
        
        currentDayKey = today
        persist()
    }
    
    
    @discardableResult
    func recordScore(mode: GameMode, score: Int) -> Bool{
        refreshForToday()
        
        guard var record = records[mode] else { return false }
        record.todayBestScore = max(record.todayBestScore, score)
        
        var justCompleted = false
        if score >= record.targetScore && !record.completedToday {
            justCompleted = completeChallenge(mode: mode, record: &record)
        }else{
            records[mode] = record
        }
        
        persist()
        return justCompleted
    }
    
    func record(for mode: GameMode) -> GameDailyChallenge {
        refreshForToday()
        return records[mode] ?? .fresh(defaultTarget: mode.baseDailyTarget)
    }
    
    var allCompletedToday: Bool {
        GameMode.allCases.allSatisfy{ records[$0]?.completedToday == true}
    }
    
    var completedCountToday: Int {
        GameMode.allCases.filter { records[$0]?.completedToday == true}.count
    }
    
    func resetAllChallenges() {
        let today = Self.dayKey(for: Date(), calendar: calendar)
        masterStreak = 0
        lastAllCompletedDay = nil
        bootstrapRecords(for: today)
        currentDayKey = today
        persist()
    }
    
    private var lastAllCompletedDay: String?
    
    private func completeChallenge(mode: GameMode, record: inout GameDailyChallenge) -> Bool {
        let today = currentDayKey
        let yesterday = Self.dayKey(
            for: calendar.date(byAdding: .day, value: -1,to:Date()) ?? Date(),
            calendar: calendar
        )
        
        record.completedToday = true
        
        if record.lastCompletedDay == yesterday {
            record.streak += 1
        }else{
            record.streak = 1
        }
        
        record.lastCompletedDay = today
        records[mode] = record
        
        if justCompletedAllToday(){
            updateMasterStreak(today: today, yesterday: yesterday)
        }
        
        AudioManager.shared.playSFX(.success)
        return true
    }
    
    private func justCompletedAllToday() -> Bool {
        allCompletedToday
    }
    
    private func updateMasterStreak(today: String, yesterday: String) {
        if lastAllCompletedDay == yesterday {
            masterStreak += 1
        }else if lastAllCompletedDay != today {
            masterStreak = 1
        }
        lastAllCompletedDay = today
    }
    
    private func handleDayTransition(from previousDay: String, to newDay: String) {
        guard
            let prevDate = Self.parseDayKey(previousDay, calendar: calendar),
            let newDate = Self.parseDayKey(newDay, calendar: calendar)
        else{
            resetAllStreaks()
            bootstrapRecords(for: newDay)
            return
        }
        
        let gap = calendar.dateComponents([.day], from: prevDate, to: newDate).day ?? 0
        
        if gap > 1 {
            resetAllStreaks()
        } else if gap == 1 {
            breakStrakssIfMissed(on: previousDay)
            breakMasterStreakIfMissed(on: previousDay)
        }
        
        for mode in GameMode.allCases {
            var record = records[mode] ?? .fresh(defaultTarget: mode.baseDailyTarget)
            record.completedToday = false
            record.todayBestScore = 0
            record.targetScore = mode.scaledDailyTarget(
                personalBest: SessionStore.shared.bestScore(for: mode) ?? 0
            )
            records[mode] = record
        }
    }
    
    private func breakStrakssIfMissed(on day: String) {
        for mode in GameMode.allCases {
            guard var record = records[mode] else { continue }
            if record.lastCompletedDay != day {
                record.streak = 0
                records[mode] = record
            }
        }
    }
    
    private func breakMasterStreakIfMissed(on day: String) {
        if lastAllCompletedDay != day {
            masterStreak = 0
        }
    }
    
    private func resetAllStreaks() {
        masterStreak = 0
        lastAllCompletedDay = nil
        for mode in GameMode.allCases {
            var record = records[mode] ?? .fresh(defaultTarget: mode.baseDailyTarget)
            record.streak = 0
            record.lastCompletedDay = nil
            records[mode] = record
        }
    }
    
    private func bootstrapRecords(for day: String) {
        for mode in GameMode.allCases {
            records[mode] = .fresh(
                defaultTarget: mode.scaledDailyTarget(
                personalBest: SessionStore.shared.bestScore(for: mode) ?? 0
                )
            )
                
        }
        currentDayKey = day
    }
    
    
    private func loadStore(){
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let store = try? JSONDecoder().decode(DailyChallengeStore.self, from: data)
                else { return }
        
        currentDayKey = store.currentDayKey
        masterStreak = store.masterStreak
        lastAllCompletedDay = store.lastAllCompletedDay
        records = Dictionary(
            uniqueKeysWithValues: store.games.compactMap{ key, value in
                guard let mode = GameMode.allCases.first(where: {$0.rawValue == key}) else {return nil}
                return (mode,value)
            }
        )
    }
    
    private func persist () {
        let games = Dictionary(uniqueKeysWithValues: records.map{($0.key.rawValue,$0.value)})
        let store = DailyChallengeStore(
            currentDayKey: currentDayKey,
            masterStreak: masterStreak,
            lastAllCompletedDay: lastAllCompletedDay,
            games: games
        )
        if let data = try? JSONEncoder().encode(store) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    static func dayKey(for date: Date, calendar: Calendar) -> String {
        let start = calendar.startOfDay(for: date)
        let y = calendar.component(.year, from: start)
        let m = calendar.component(.month, from: start)
        let d = calendar.component(.day, from: start)
        return String(format: Const.dateFormat, y,m,d)
    }
    
    private static func parseDayKey(_ key: String, calendar: Calendar) -> Date? {
        let parts = key.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))
        
    }
    
}
