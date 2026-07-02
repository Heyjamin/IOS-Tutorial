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
    
    var id: Self {self}
}
