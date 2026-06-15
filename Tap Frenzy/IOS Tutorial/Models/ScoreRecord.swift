//
//  ScoreRecord.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//
import SwiftUI

struct ScoreRecord: Codable, Identifiable{
    var id = UUID()
    
    var playerName: String
    
    var score: Int
    
    var gameName: String
    
    var date: Date
}
