//
//  RootView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-19.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage("currentPlayer")
    private var playerName = ""
    
    var body: some View {
        if playerName.isEmpty {
            PlayerRegistrationView()
        }else{
            ArenaView()
        }
    }
}
