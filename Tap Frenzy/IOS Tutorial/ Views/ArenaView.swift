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
    @State private var goLightItUp = false
    
    @State private var showLeaderboard = false
    
    
    
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
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ){
                            Button{
                                goTapFrenzy = true
                            } label: {
                                VStack(spacing:10){
                                    Image(systemName:"bolt.fill")
                                        .font(.system(size:30))
                                        .foregroundColor(.yellow)
                                    
                                    Text("Tap Frenzy")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height:120)
                                .glassCard()
                            }
                            .navigationDestination(
                                isPresented: $goTapFrenzy,){
                                    TapFrenzyView()
                                }
                            
                            Button {
                                goLightItUp = true
                            }label: {
                                VStack(spacing:10){
                                    Image(systemName:"square.grid.3x3.fill")
                                        .font(.system(size:30))
                                        .foregroundColor(.neonBlue)
                                    
                                    Text("Light It Up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height:120)
                                .glassCard()
                            }.navigationDestination(
                                isPresented: $goLightItUp,){
                                    LightItUpView()
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
                        } label:{
                            Label("Change Player",
                                  systemImage: "person.crop.circle.badge.xmark")
                        }
                        .foregroundColor(.neonRed)
                        
                    }
                    
                    .padding()
                    
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
