//
//  IOS_TutorialApp.swift
//  IOS Tutorial
//
//  Created by student5 on 2026-06-06.
//

import SwiftUI

@main
struct IOS_TutorialApp: App {
    var body: some Scene {
       
            @AppStorage("currentPlayer")
            var playerName = ""
            
            WindowGroup {
                if playerName.isEmpty {
                    PlayerRegistrationView()
                }else{
                    ArenaView()
                }
            }
        
    }
}
