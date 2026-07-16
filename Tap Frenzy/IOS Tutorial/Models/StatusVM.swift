//
//  StatusVM.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import Foundation
import Combine

@MainActor
class StatsVM: ObservableObject {
    @Published var sessions: [GameSession] = []
    
    func reload() {
        sessions = SessionStore.shared.loadSessions()
            .sorted { $0.timestamp > $1.timestamp}
    }
    
    var totalGames: Int { sessions.count}
    
    var totalScore: Int{
        sessions.reduce(0) { $0 + $1.score }
    }
    
    var recentSessions: [GameSession]{
        Array(sessions.prefix(10))
    }
    
    func bestScore(for mode: GameMode) -> Int {
        sessions
            .filter { $0.mode == mode }
            .map(\.score)
            .max() ?? 0
    }
    
    func sessions(for mode: GameMode) -> [GameSession]{
        sessions.filter { $0.mode == mode }
    }
}
