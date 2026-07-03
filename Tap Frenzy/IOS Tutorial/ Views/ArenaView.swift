//
//  ArenaView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI

struct ArenaView: View {
    
    @AppStorage("currentPlayer")
    private var playerName = ""
    
    @State private var selectedGame: GameDestination?
    
    @State private var showLeaderboard = false
    
    private let games = [
        GameInfo(
            title: "Tap Frenzy",
            subtitle: "Speed Challenge",
            icon: "bolt.fill",
            colorName: "yellow",
            destination: .tapFrenzy
        ),
        GameInfo(
            title: "Light It Up",
            subtitle: "Memory Game",
            icon: "square.grid.3x3.fill",
            colorName: "blue",
            destination: .lightItUp
        ),
        GameInfo(
            title: "Quiz Rush",
            subtitle: "Live Trivia",
            icon: "questionmark.circle.fill",
            colorName: "purple",
            destination: .quizRush
        )
        
    ]
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                LinearGradient(
                    colors:[.bgTop,
                            .black,
                            .bgBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                    
                )
                .ignoresSafeArea()
                ScrollView {
                    
                    VStack(spacing:20) {
                        Text("⚡ NEON ARCADE ⚡")
                            .font(.system(size:36, weight:.black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.neonBlue,
                                             .neonPurple,
                                             .neonPink
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Welcome Back")
                            .foregroundColor(.gray)
                        
                        Text(playerName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("🎮 AVAILABLE GAMES 🎮")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.neonBlue)
                            .frame(height: 140)
                        
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible()),count:3),
                            spacing: 16
                        ){
                            ForEach(games){ game in
                                GameCard(game: game){
                                    selectedGame = game.destination
                                }
                            }
                            
                        }

                        Spacer()
                        
                        
                        Button{
                            showLeaderboard = true
                        } label: {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .font(.title2)
                                
                                VStack(alignment: .leading){
                                    Text ("Leaderboards")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("View Top Players")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .glassCard()
                        }
                        
                        Button{
                            playerName = ""
                            PlayerManager.shared.savePlayer("")
                        } label:{
                            Label("Change Player",
                                  systemImage: "person.crop.circle.badge.xmark")
                        }
                        .foregroundColor(.neonRed)
                        
                    }
                    
                    .padding()
                    
                }
                .navigationDestination(item: $selectedGame){ destination in
                    
                    switch destination{
                    case .tapFrenzy:
                        TapFrenzyView()
                        
                    case .lightItUp:
                        LightItUpView()
                        
                    case .quizRush:
                        QuizRushView()
                    }
                }
                .sheet(isPresented: $showLeaderboard){
                    NavigationStack{
                        LeaderboardView()
                    }
                }
            }
        }
    }
}

#Preview {
    ArenaView()
}
