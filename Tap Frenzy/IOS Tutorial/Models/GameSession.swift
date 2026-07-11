//
//  GameSession.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-07.
//

import Foundation

struct GameSession: Codable, Identifiable, Hashable{
    let id: UUID
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    init(mode: GameMode, score: Int, latitude: Double, longitude: Double){
        self.id = UUID()
        self.mode = mode
        self.score = score
        self.timestamp = Date()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var hasValidLocation: Bool{
        latitude != 0 || longitude != 0
    }
}
