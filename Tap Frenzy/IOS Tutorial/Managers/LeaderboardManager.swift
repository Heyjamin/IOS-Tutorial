//
//  LeaderboardManager.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import Foundation

class LeaderboardManager {
    static let shared = LeaderboardManager()
    
    private let key = "leaderboardScores"
    
    private init(){}
    
    
    func loadScores() -> [ScoreRecord]{
        guard let data = UserDefaults.standard.data(
            forKey: key)
        else{
            return []
        }
        
        do {
            return try JSONDecoder().decode([ScoreRecord].self, from: data)
        }catch{
            return []
        }
    }
    
    func saveScores (_ scores: [ScoreRecord]) {
        do {
            let data = try JSONEncoder().encode(scores)
            
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
        
    }
    
    func addScore (
        playerName: String,
        score: Int,
        gameName: String
        
    ){
        var scores = loadScores()
        
        let record = ScoreRecord (
            playerName: playerName,
            score:score,
            gameName: gameName
        )
        
        scores.append(record)
        
        saveScores(scores)
    }
    
    func topScores(
        for gameName: String) -> [ScoreRecord] {
            loadScores()
            
                .filter{
                    $0.gameName == gameName
                }
            
                .sorted {
                    $0.score > $1.score
                    
                }
            
                .prefix(10)
            
                .map { $0 }
        }
    
}
