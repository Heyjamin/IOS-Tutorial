//
//  LevelProgressStore.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import Foundation
import Combine

struct LevelRecord: Codable{
    var bestStars: Int
    var bestScore: Int
}


@MainActor
final class LevelProgressStore: ObservableObject {
    
    static let shared = LevelProgressStore()
    
    private let key = Const.txtLevelProgressStore
    @Published private(set) var records: [String: LevelRecord] = [:]
    
    private init() {
        load()
        ensureLevelOneUnlocked()
    }
    
    private func storageKey(mode: GameMode, level: Int) -> String {
        "\(mode.rawValue)-\(level)"
    }
    
    func isUnlocked(mode: GameMode, level: Int) -> Bool {
        if level <= 1 {return true}
        return bestStars(mode: mode, level: level - 1) >= GameLevelConfig.unlockStarsRequired
    }
    
    func bestStars(mode: GameMode, level: Int) -> Int {
        records[storageKey(mode: mode, level: level)]?.bestStars ?? 0
    }
    
    func bestScore(mode: GameMode, level: Int) -> Int {
        records[storageKey(mode: mode, level: level)]?.bestScore ?? 0
    }
    
    @discardableResult
    func recordResult(mode: GameMode, level: Int, score: Int) -> (stars: Int, isNewBest: Bool) {
        let config = GameLevelConfig.config(mode: mode, level: level)
        let stars = config.stars(for: score)
        let mapKey = storageKey(mode: mode, level: level)
        var record = records[mapKey] ?? LevelRecord(bestStars: 0, bestScore: 0)
        let isNewBest = score > record.bestScore || stars > record.bestStars
        record.bestScore = max(record.bestScore, score)
        record.bestStars = max(record.bestStars, stars)
        records[mapKey] = record
        persist()
        if stars >= 3 {
            AudioManager.shared.playSFX(.success)
        }
        
        return (stars, isNewBest)
    }
    
    func canUnlockNext(mode: GameMode, level: Int, stars: Int) -> Bool{
        stars >= GameLevelConfig.unlockStarsRequired
        && level < GameLevelConfig.levelsPerGame(for: mode)
        && isUnlocked(mode: mode, level: level + 1) == false
        && bestStars(mode: mode, level: level) >= GameLevelConfig.unlockStarsRequired
    }
    
    func nextPlayableLevel(mode: GameMode, after level: Int) -> Int? {
        let next = level + 1
        guard next <= GameLevelConfig.levelsPerGame(for: mode), isUnlocked(mode: mode, level: next) else { return nil}
        return next
    }
    
    func resetAll(){
        records = [:]
        persist()
        ensureLevelOneUnlocked()
    }
    
    private func ensureLevelOneUnlocked(){
        for mode in GameMode.allCases {
            let mapKey = storageKey(mode: mode, level: 1)
            if records[mapKey] == nil {
                records[mapKey] = LevelRecord(bestStars: 0, bestScore: 0)
            }
        }
        persist()
    }
    
    private func load(){
        guard let data = UserDefaults.standard.data(forKey: key),
        let decoded = try? JSONDecoder().decode([String: LevelRecord].self, from: data)
        else {return}
        records = decoded
        
    }
    
    private func persist(){
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
