//
//  ArenaView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//

import SwiftUI

struct PlayerRegistrationView : View {
    
    @AppStorage("currentPlayer")
    private var savedPlayerName = ""
    
    @State private var playerName = ""
    
    @State private var goArena = false
    
    func savePlayer() {
        let trimmed =
        playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else { return }
        
        savedPlayerName = trimmed
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(
                    colors: [Color.bgTop,
                             Color.black,
                             Color.bgBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(spacing:25){
                    Text("⚡ NEON ARCADE ⚡")
                        .font(.system(size:36,weight: .black))
                        .foregroundStyle(
                            LinearGradient(colors: [
                                .neonBlue,
                                .neonPurple,
                                .neonPink
                            ], startPoint: .leading, endPoint: .trailing))
                    Text("Welcome to the Neon Arcade")
                        .foregroundStyle(
                            Color.white
                        )
                    
                    TextField(
                        "Enter your name",
                        text: $playerName
                    )
                    .padding()
                    .foregroundColor(.white)
                    .tint(.neonBlue)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                    ).overlay(
                        RoundedRectangle(cornerRadius:16)
                            .stroke(Color.neonBlue, lineWidth: 1)
                    )
                    
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.neonBlue, lineWidth: 1)
                        
                    )
                    .foregroundColor(.white)
                    
                    
                    Button {
                        savePlayer()
                        
                        goArena = true
                    } label: {
                        Text("SAVE PLAYER")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(LinearGradient(
                                colors:
                                    [
                                        .neonBlue,
                                        .neonPurple
                                    ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            )
                            .cornerRadius(16)
                    }
                    .navigationDestination(
                        isPresented: $goArena,
                    ){
                        ArenaView()
                    }
                    
                    if !savedPlayerName.isEmpty {
                        VStack (spacing:8) {
                            Text("CURRENT PLAYER")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.neonGreen)
                            
                            
                            Text(savedPlayerName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .glassCard()
                    }
                }
                .padding()
            }
        }
        
    }
}

#Preview {
    PlayerRegistrationView()
}
