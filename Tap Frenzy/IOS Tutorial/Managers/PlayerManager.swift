//
//  PlayerManager.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//

import SwiftUI

class PlayerManager {
    
    static let shared = PlayerManager()
    
    private init() {}
    
    var currentPlayer: String {
        
        UserDefaults.standard.string(forKey: "CurrentPlayer") ?? ""
    }
    
    func savePlayer(_ name: String) {
        UserDefaults.standard.set(name, forKey: "CurrentPlayer")
        
    }
}
