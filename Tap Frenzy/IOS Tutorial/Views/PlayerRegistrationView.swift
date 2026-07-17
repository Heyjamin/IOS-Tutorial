//
//  ArenaView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//

import SwiftUI

struct PlayerRegistrationView : View {
    
    @AppStorage(Const.txtCurrentPlayer)
    private var savedPlayerName = ""
    
    @State private var playerName = ""
    
    @State private var goArena = false
    
    func savePlayer() {
        let trimmed =
        playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else { return }
        
        savedPlayerName = trimmed
        PlayerManager.shared.savePlayer(trimmed)
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                NeonAnimatedBackground(style: .menu)
                
                VStack(spacing:25){
                    Text(Const.flash + " " + Const.txtNeonArcade.uppercased() + " " + Const.flash )
                        .font(.system(size:36,weight: .black))
                        .foregroundStyle(
                            LinearGradient(colors: [
                                .neonBlue,
                                .neonPurple,
                                .neonPink
                            ], startPoint: .leading, endPoint: .trailing))
                    Text(Const.txtWelcome)
                        .foregroundStyle(
                            Color.white
                        )
                    
                    TextField(
                        Const.txtEnterName,
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
                        AudioManager.shared.playSFX(.button)
                        savePlayer()
                        goArena = true
                    } label: {
                        Text(Const.txtSavePlayer)
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
                        MainTabView()
                    }
                    
                    if !savedPlayerName.isEmpty {
                        VStack (spacing:8) {
                            Text(Const.txtCurrentPlayerName.uppercased())
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
            .onAppear {
                AudioManager.shared.configureSession()
                AudioManager.shared.playMusic(.menu)
            }
        }
    }
}

#Preview {
    PlayerRegistrationView()
}
