//
//  GameLevel.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-07.
//

import SwiftUI

enum LevelDiffiiculty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: Color {
        switch self {
        case .easy:
            return .neonGreen
        case .medium:
            return .yellow
        case .hard:
            return .neonRed
        }
    }
}

enum Leveelworld: Int, CaseIterable {
    case meadow = 1
    case ocian = 2
    case sunset = 3
    case volcano = 4
    case cosmos = 5
    
    var title:String {
        switch self {
        case .meadow:
            return "Neon Meadow"
        case .ocian:
            return "Crystal cian"
        case .sunset:
            return "Sunset Arena"
        case .volcano:
            return "Volcano Core"
        case .cosmos:
            return "Cosmos Void"
        }
    }
    
    var orbColors: [Color] {
        WorldPalette.forWorld(self).aurora
    }
    
    var gradientColos: [Color] {
        let p = WorldPalette.forWorld(self)
        return [p.base, p.base.opacity(0.6),p.base]
    }
    
    static func forLevel(_ level: Int) -> Leveelworld {
        let index = ((level-1) % Leveelworld.allCases.count) + 1
        return Leveelworld(rawValue:inex) ?? .meadow
    }
    
}

struct GameLevelConfig: Identifiable {
    let number: Int
    let mode: GameMode
    let difficulty: LevelDiffiiculty
    let subtitle: String
    let world: Leveelworld
    /// Min scores for 1* ... 5*
    let starThresholds: [Int]
    
    var id: String {"\(mode.rawValue)-\(number)"}
    
    func stars(for score: Int) -> Int{
        var earned = 0
        for (index, threshold) in starThresholds.enumerated() {
            if score >= threshold {
                earned = index + 1
            }
            return earned
        }
        
        static let levelsPerGame = 10
        static let unlockStarsRequired = 3
        
        static func levelsPerGame(for mode: GameMode) -> Int {
            levelsPerGame
        }
        
        static func config(mode: GameMode,, level: Int) -> GameLevelConfig {
            let clamped = min(max(level, 1), levelsPerGame(for: mode))
            switch mode {
            case .tapFrenzy: return tapFrenzyLevels[clamped - 1]
            case .lightItUp: return lightItUpLevels[clamped - 1]
            case .quizRush: return quizRushLevels[clamped - 1]
            }
        }
        
        static func allLevels(for mode: GameMode) -> [GameLevelConfig]{
            (1...levelsPerGame(for: mode)).map { config(mode: mode, level: $0)}
        }
        
        // LEVELS: Tap Frenzy
        
        static let tapFrenzyLevels: [GameLevelConfig] = [
            GameLevelConfig(number: 1, mode: .tapFrenzy, difficulty: .easy, subtitle: "Warm Up", world: .meadow, starThresholds: [4,12,20,28,38]),
            GameLevelConfig(number: 2, mode: .tapFrenzy, difficulty: .easy, subtitle: "Getting Faster", world: .ocian, starThresholds: [6,14,22,32,42]),
            GameLevelConfig(number: 3, mode: .tapFrenzy, difficulty: .easy, subtitle: "Combo Zone", world: .sunset, starThresholds: [8,16,25,35,48]),
            GameLevelConfig(number: 4, mode: .tapFrenzy, difficulty: .medium, subtitle: "Chaos Mode", world: .volcano, starThresholds: [10,18,28,40,52]),
            GameLevelConfig(number: 5, mode: .tapFrenzy, difficulty: .medium, subtitle: "Speed Rush", world: .cosmos, starThresholds: [12,20,30,42,58]),
            GameLevelConfig(number: 6, mode: .tapFrenzy, difficulty: .medium, subtitle: "Hyper Tap", world: .meadow, starThresholds: [14,22,34,48,64]),
            GameLevelConfig(number: 7, mode: .tapFrenzy, difficulty: .medium, subtitle: "Blur Speed", world: .ocian, starThresholds: [16,24,36,50,66]),
            GameLevelConfig(number: 8, mode: .tapFrenzy, difficulty: .hard, subtitle: "Frenzy Mode", world: .sunset, starThresholds: [18,28,40,54,70]),
            GameLevelConfig(number: 9, mode: .tapFrenzy, difficulty: .hard, subtitle: "Insane Combo", world: .volcano, starThresholds: [20,30,44,60,78]),
            GameLevelConfig(number: 10, mode: .tapFrenzy, difficulty: .hard, subtitle: "Ultimate Legend", world: .cosmos, starThresholds: [22,34,48,64,85]),
        ]
        
        
        // LEVELS: Light It Up
        
        static let lightItUpLevels: [GameLevelConfig] = [
            GameLevelConfig(number: 1, mode: .lightItUp, difficulty: .easy, subtitle: "First Lights", world: .meadow, starThresholds: [4,8,14,20,28]),
            GameLevelConfig(number: 2, mode: .lightItUp, difficulty: .easy, subtitle: "Quick Hands", world: .ocian, starThresholds: [6,10,16,24,34]),
            GameLevelConfig(number: 3, mode: .lightItUp, difficulty: .easy, subtitle: "Soft Glow", world: .sunset, starThresholds: [8,12,18,28,40]),
            GameLevelConfig(number: 4, mode: .lightItUp, difficulty: .medium, subtitle: "Trap Alley", world: .volcano, starThresholds: [10,14,20,30,44]),
            GameLevelConfig(number: 5, mode: .lightItUp, difficulty: .medium, subtitle: "Danger Grid", world: .cosmos, starThresholds: [12,16,24,36,52]),
            GameLevelConfig(number: 6, mode: .lightItUp, difficulty: .medium, subtitle: "Speed Grid", world: .meadow, starThresholds: [14,18,26,38,54]),
            GameLevelConfig(number: 7, mode: .lightItUp, difficulty: .medium, subtitle: "Flash Matrix", world: .ocian, starThresholds: [16,20,28,40,58]),
            GameLevelConfig(number: 8, mode: .lightItUp, difficulty: .hard, subtitle: "Inferno Titles", world: .sunset, starThresholds: [18,22,30,44,60]),
            GameLevelConfig(number: 9, mode: .lightItUp, difficulty: .hard, subtitle: "Nightmare Grid", world: .volcano, starThresholds: [20,24,34,48,68]),
            GameLevelConfig(number: 10, mode: .lightItUp, difficulty: .hard, subtitle: "Master Grid", world: .cosmos, starThresholds: [22,26,38,54,72]),
        ]
        
        // LEVELS: Quiz Rush
        
        static let quizRushLevels: [GameLevelConfig] = [
            GameLevelConfig(number: 1, mode: .quizRush, difficulty: .easy, subtitle: "Warm-Up Quiz", world: .meadow, starThresholds: [10,20,30,40,50]),
            GameLevelConfig(number: 2, mode: .quizRush, difficulty: .easy, subtitle: "Brain Boost", world: .ocian, starThresholds: [15,28,34,40,65]),
            GameLevelConfig(number: 3, mode: .quizRush, difficulty: .easy, subtitle: "Think Fast", world: .sunset, starThresholds: [20,35,48,62,78]),
            GameLevelConfig(number: 4, mode: .quizRush, difficulty: .medium, subtitle: "Quick Recall", world: .volcano, starThresholds: [25,40,50,70,90]),
            GameLevelConfig(number: 5, mode: .quizRush, difficulty: .medium, subtitle: "Expert Round", world: .cosmos, starThresholds: [30,45,60,80,100]),
            GameLevelConfig(number: 6, mode: .quizRush, difficulty: .medium, subtitle: "Brain Storm", world: .meadow, starThresholds: [35,50,70,90,110]),
            GameLevelConfig(number: 7, mode: .quizRush, difficulty: .medium, subtitle: "Rapid Fire", world: .ocian, starThresholds: [40,55,80,100,120]),
            GameLevelConfig(number: 8, mode: .quizRush, difficulty: .hard, subtitle: "Genius Only", world: .sunset, starThresholds: [45,60,85,110,135]),
            GameLevelConfig(number: 9, mode: .quizRush, difficulty: .hard, subtitle: "Mind Blitz", world: .volcano, starThresholds: [55,70,95,120,143]),
            GameLevelConfig(number: 9, mode: .quizRush, difficulty: .hard, subtitle: "Ultimate Quiz", world: .volcano, starThresholds: [60,88,110,135,160),
            
        ]
        
    }
    
    // Tap Frenzy level gameplay
    
    struct TapFrenzyLevelSettings{
        let durationMs: Int
        let moveInterval: Double
        let emojiInterval: Double
        let normalemoji: String
        let bonusEmoji: String
        let penaltyEmoji: String
        let bonusPoints: Int
        let specialChance: Double
        
        static func settings(for level: Int) -> TapFrenzyLevelSettings {
            switch level {
            case 1: return TapFrenzyLevelSettings(durationMs: 13_000, moveInterval: 2.6, emojiInterval: 3.8, normalemoji: "🖐️", bonusEmoji: "✨", penaltyEmoji: "☠️", bonusPoints: 3, specialChance: 0.12)
            case 2: return TapFrenzyLevelSettings(durationMs: 12_000, moveInterval: 2.3, emojiInterval: 3.2, normalemoji: "😀", bonusEmoji: "🌟", penaltyEmoji: "😡", bonusPoints: 3, specialChance: 0.15)
            case 3: return TapFrenzyLevelSettings(durationMs: 11_000, moveInterval: 2.0, emojiInterval: 2.8, normalemoji: "😇", bonusEmoji: "💎", penaltyEmoji: "🧨", bonusPoints: 4, specialChance: 0.18)
            case 4: return TapFrenzyLevelSettings(durationMs: 10_500, moveInterval: 1.75, emojiInterval: 2.4, normalEmoji: "😃", bonusEmoji: "🎯", penaltyEmoji: "☠️", bonusPoints: 4, specialChance: 0.20)
            case 5: return TapFrenzyLevelSettings(durationMs: 10_000, moveInterval: 1.55, emojiInterval: 2.1, normalEmoji: "🙂", bonusEmoji: "💫", penaltyEmoji: "💥", bonusPoints: 4, specialChance: 0.22)
            case 6: return TapFrenzyLevelSettings(durationMs: 9_500, moveInterval: 1.35, emojiInterval: 1.9, normalEmoji: "🤗", bonusEmoji: "⚡", penaltyEmoji: "💀", bonusPoints: 5, specialChance: 0.24)
            case 7: return TapFrenzyLevelSettings(durationMs: 9_000, moveInterval: 1.2, emojiInterval: 1.7, normalEmoji: "😁", bonusEmoji: "🚀", penaltyEmoji: "☠️", bonusPoints: 5, specialChance: 0.26)
            case 8: return TapFrenzyLevelSettings(durationMs: 8_500, moveInterval: 1.0, emojiInterval: 1.5, normalEmoji: "☺️", bonusEmoji: "🪎", penaltyEmoji: "😈",bonusPoints: 5, specialChance: 0.28)
            case 9: return TapFrenzyLevelSettings(durationMs: 8_000, moveInterval: 0.85, emojiInterval: 1.25, normalEmoji: "🥰", bonusEmoji: "🏆", penaltyEmoji: "🧨", bonusPoints: 6, specialChance: 0.30)
            default: return TapFrenzyLevelSettings(durationMs: 7_500, moveInterval: 0.72, emojiInterval: 1.05,normalEmoji: "🤩", bonusEmoji: "👑", penaltyEmoji: "👹", bonusPoints: 6, specialChance: 0.32)
            }
        }
    }
    
    enum TapEmojiMode{
        case normal
        case bonus
        case penalty
    }
    
    // Light It Up level gamePlay
    
    struct LightItUpLevelSettings{
        let duration: Int
        let visibleCards: Int
        let columns: Int
        let lightSpeed: Double
        let cellDisplayDuration: Double
        let bonusChance: Double
        let trapChance: Double
        let bonusPoints: Int
        let trapPenalty: Int
        
        static func settings (for level: Int) ->LightItUpLevelSetings {
            switch level {
            case 1:
                return LightItUpLevelSettings(duration: 80, visibleCards: 3, columns: 3, lightSpeed: 1.55, cellDisplayDuration: 2.1, bonusChance: 0.18, trapChance: 0.0, bonusPoints: 3, trapPenalty: 1
                )
            case 2:
                return LightItUpLevelSettings(duration: 75, visibleCards: 3, columns: 3, lightSpeed: 1.4, cellDisplayDuration: 1.9, bonusChance: 0.16, trapChance: 0.0, bonusPoints: 3, trapPenalty: 1
                )
            case 3:
                return LightItUpLevelSettings(duration: 70, visibleCards: 4, columns: 2, lightSpeed: 1.3, cellDisplayDuration: 1.75, bonusChance: 0.14, trapChance: 0.0, bonusPoints: 3, trapPenalty: 1
                )
            case 4:
                return LightItUpLevelSettings(duration: 62, visibleCards: 6, columns: 3, lightSpeed: 1.05, cellDisplayDuration: 0.85, bonusChance: 0.14, trapChance: 0.06, bonusPoints: 3, trapPenalty: 2
                )
            case 5:
                return LightItUpLevelSettings(duration: 58, visibleCards: 5, columns: 3, lightSpeed: 0.95, cellDisplayDuration: 0.78, bonusChance: 0.13, trapChance: 0.10, bonusPoints: 3, trapPenalty: 2
                )
            case 6:
                return LightItUpLevelSettings(duration: 56, visibleCards: 6, columns: 3, lightSpeed: 0.85, cellDisplayDuration: 0.72, bonusChance: 0.12, trapChance: 0.12, bonusPoints: 3, trapPenalty: 2
                )
            case 7:
                return LightItUpLevelSettings (duration: 54, visibleCards: 9, columns: 3, lightSpeed: 0.78, cellDisplayDuration: 0.65, bonusChance: 0.12, trapChance: 0.14, bonusPoints: 3, trapPenalty: 2
                )
            case 8:
                return LightItUpLevelSettings(duration: 50, visibleCards: 9, columns: 3, lightSpeed: 0.68, cellDisplayDuration: 0.58, bonusChance: 0.11, trapChance: 0.16, bonusPoints: 3, trapPenalty: 3
                )
            case 9:
                return LightItUpLevelSettings(duration: 48, visibleCards: 9, columns: 3, lightSpeed: 0.62, cellDisplayDuration: 0.52, bonusChance: 0.10, trapChance: 0.18, bonusPoints: 4, trapPenalty: 3
                )
            default:
                return LightItUpLevelSettings(duration: 45, visibleCards: 9, columns: 3, lightSpeed: 0.56, cellDisplayDuration: 0.48, bonusChance: 0.10, trapChance: 0.20, bonusPoints: 4, trapPenalty: 3
                )
            }
        }
    }
    
    enum LightCelKind {
        case normal
        case bonus
        case trap
        
        var emoji: String{
            switch self{
            case .normal: return "🖐️"
            case .bonus: return "🌟"
            case .trap: return "💣"
            }
        }
    }
    
    // Quiz Rush level gamePlay
    
    struct QuizRushLevelSettings {
        let questionCount: Int
        let questionTimeLimit: Double
        let maxTimeBonus: Int
        let answerDelayCorrect: Double
        let answerDelayWrong: Double
        
        static func settings(for level: Int) -> QuizRushLevelSettings {
            switch level {
            case 1:
                return QuizRushLevelSettings(questionCount: 5, questionTimeLimit: 20, maxTimeBonus: 10, answerDelayCorrect: 1.0, answerDelayWrong: 2.0)
            case 2:
                return QuizRushLevelSettings(questionCount: 6, questionTimeLimit: 17, maxTimeBonus: 11, answerDelayCorrect: 1.0, answerDelayWrong: 2.1)
            case 3:
                return QuizRushLevelSettings(questionCount: 6, questionTimeLimit: 16, maxTimeBonus: 11, answerDelayCorrect: 1.0, answerDelayWrong: 2.0)
            case 4:
                return QuizRushLevelSettings(questionCount: 8, questionTimeLimit: 14, maxTimeBonus: 12, answerDelayCorrect: 1.0, answerDelayWrong: 2.1)
            case 5:
                return QuizRushLevelSettings(questionCount: 8, questionTimeLimit: 12, maxTimeBonus: 12, answerDelayCorrect: 1.0, answerDelayWrong: 2.2)
            case 6:
                return QuizRushLevelSettings(questionCount: 9, questionTimeLimit: 12, maxTimeBonus: 13, answerDelayCorrect: 1.0, answerDelayWrong: 2.2)
            case 7:
                return QuizRushLevelSettings(questionCount: 10, questionTimeLimit: 11, maxTimeBonus: 13, answerDelayCorrect: 1.0, answerDelayWrong: 2.3)
            case 8:
                return QuizRushLevelSettings(questionCount: 10, questionTimeLimit: 9, maxTimeBonus: 14, answerDelayCorrect: 1.0, answerDelayWrong: 2.3)
            case 9:
                return QuizRushLevelSettings(questionCount: 10, questionTimeLimit: 8, maxTimeBonus: 15, answerDelayCorrect: 0.9, answerDelayWrong: 2.4)
            default:
                return QuizRushLevelSettings(questionCount: 10, questionTimeLimit: 7, maxTimeBonus: 15, answerDelayCorrect: 0.9, answerDelayWrong: 2.5)
            }
        }
    }
}

struct GameLevelRoute: Hashable{
    let mode: GameMode
    let level: Int
}
