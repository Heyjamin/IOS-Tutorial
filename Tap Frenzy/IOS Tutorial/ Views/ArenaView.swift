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
    
    @State private var goTapFrenzy = false
    @State private var showLeaderboard = false
    
    private var champion: ScoreRecord? {
        LeaderboardManager.shared.topScores(for: "Tap Frenzy").first
    }
    
    
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
                    
                
                    if champion == nil {

                        VStack(spacing: 8) {

                            Label("CURRENT CHAMPION", systemImage:"crown.fill")
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)

                            Text("No Champion Yet")
                                .foregroundColor(.gray)

                            Text("Play Tap Frenzy")
                                .foregroundColor(.neonBlue)

                        }
                        .glassCard()
                    }
                    
                    if let champion = champion {
                        
                        VStack(spacing: 8){
                            Label("CURRENT CHAMPION", systemImage:"crown.fill")
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)

                            Text(champion.playerName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("\(champion.score) Points")
                                .foregroundColor(.neonGreen)
                        }
                        .glassCard()
                    }
                    Spacer()
                    Button{
                        goTapFrenzy = true
                    } label: {
                        GameCard(
                            title: "Tap Frenzy",
                            icon: "bolt.fill",
                            description:"Fast Tapping Challenge"
                            
                        )
                    }.navigationDestination(
                        isPresented: $goTapFrenzy
                    ){
                        TapFrenzyView()
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
                    .sheet(isPresented: $showLeaderboard){
                        NavigationStack{
                            LeaderboardView(
                                gameName: "Tap Frenzy"
                            )
                        }
                    }
                    
                }
                .padding()
                
            }
        }
    }
}

#Preview {
    ArenaView()
}
