//
//  GameInfo.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//

import Foundation

struct GameInfo: Identifiable {
    let id = UUID()
    
    let title: String
    let subtitle: String
    let icon: String
    let colorName: String
    
    let destination: GameDestination
}

enum GameDestination: Hashable, Identifiable{
    case tapFrenzy
    case lightItUp
    case quizRush
    case levelSelect(GameMode)
    
    var id: String{
        switch self {
        case .tapFrenzy: return "tapFrenzy"
        case .lightItUp: return "lightItUp"
        case .quizRush: return "quizRush"
        case .levelSelect(let mode): return "levels-\(mode.rawValue)"
        }
    }
}
