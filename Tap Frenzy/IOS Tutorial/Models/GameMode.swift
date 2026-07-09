//
//  GameMode.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-07.
//

import Foundation

enum GameMode: String, Codable, CaseIterable, Identifiable, Hashable{
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .tapFrenzy: return "bolt.fill"
        case .lightItUp: return "square.grid.3x3.fill"
        case .quizRush: return "questionmark.circle.fill"
        }
    }
    
    var subtitle: String{
        switch self{
        case .tapFrenzy: return "Speed Challenge"
        case .lightItUp: return "Memory Game"
        case .quizRush: return "Live Trivia"
        }
    }
    
    var colorName: String{
        switch self{
        case .tapFrenzy: return "yellow"
        case .lightItUp: return "blue"
        case .quizRush: return "purple"
        }
    }
    
    var destination: GameDestination {
        switch self {
        case .tapFrenzy: return .levelSelect(.tapFrenzy)
        case .lightItUp: return .levelSelect(.lightItUp)
        case .quizRush: return .levelSelect(.quizRush)
        }
    }
}
