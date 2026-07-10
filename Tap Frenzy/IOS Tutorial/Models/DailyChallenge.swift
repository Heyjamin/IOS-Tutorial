//
//  DailyChallenge.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-09.
//

import Foundation

struct GameDailyChallenge: Codable, Equatable{
    var targetScore: Int
    var streak: Int
    var completedToday: Bool
    var todayBestscore: Int
    var lastCompletedDay: String?
    
    static func fresh(defaultTarget: Int) -> GameDailyChallenge {
        GameDailyChallenge(
            targetScore: defaultTarget, streak: 0, completedToday: false, todayBestscore: 0, lastCompletedDay: nil
        )
    }
}

struct DailyChallengeScore: Codable{
    var currentDayKey: String
    var masterStreak: Int
    var lastAllCompletedDay: String?
    var games: [String: GameDailyChallenge]
}

extension GameMode{
    var baseDailyTarget: Int{
        switch self {
        case .tapFrenzy: return 20
        case .lightItUp: return 12
        case .quizRush: return 40
        }
    }
    
    func scaledDailyTarget(personalBest: Int) -> Int{
        guard personalBest > 0 else {
            return baseDailyTarget
        }
        let scaled = Int(Double(personalBest) * 0.55)
        return max(baseDailyTarget, min(scaled, personalBest))
    }
}
