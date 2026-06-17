//
//  ScoreRecord.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//
import Foundation

struct ScoreRecord: Codable, Identifiable{
    
    let id : UUID
    
    let playerName: String
    
    let score: Int
    
    let gameName: String
    
    let date: Date
    
    init (
        
        playerName: String,
        score: Int,
        gameName: String
        
    ){
        self.id = UUID()
        self.playerName = playerName
        self.score = score
        self.gameName = gameName
        self.date = Date()
    }
}
