//
//  SessionStore.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import Foundation
import CoreLocation

class SessionStore {
    static let shared = SessionStore()
    
    private let key = "gameSessions"
    
    private init() {}
    
    func loadSessions() -> [GameSession]{
    guard let data = UserDefaults.standard.data(forKey: key) else {
            return[]
        }
        do {
            return try JSONDecoder().decode([GameSession].self, from: data)
        }catch{
            return []
        }
    }
    
    func saveSessions(_ sessions: [GameSession]) {
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print ("SessionStore save error: ", error)
        }
    }
    
    func recordSession(mode: GameMode, score: Int){
        guard score > 0 || mode == .quizRush else { return }
        
        let location = LocationService.shared.currentLocation ?? MapDefaults.colombo
        let session = GameSession(
            mode: mode,
            score: score,
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        var sessions = loadSessions()
        sessions.append(session)
        saveSessions(sessions)
        
        DailyChallengeManager.shared.recordScore(mode: mode, score: score)
    }
    
    func clearAll(){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func bestScore(for mode: GameMode) -> Int? {
        loadSessions()
            .filter { $0.mode == mode}
            .map(\.score)
            .max()
    }
    
}
