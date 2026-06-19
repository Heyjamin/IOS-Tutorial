//
//  LeaderboardView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI



struct LeaderboardView: View {
    
    let gameName: String
    private let manager = LeaderboardManager.shared
    
    private var champion: LeaderboardManager.PlayerStatus?{
        manager.arcadeChampion()
    }
    
    private var scores :[ScoreRecord]{
        manager.topScores(for:gameName)
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [.bgTop,
                         .black,
                         .bgBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if scores.isEmpty {
                VStack(spacing: 20){
                    Image(systemName: "trophy.fill")
                        .font(.system(size:80))
                        .foregroundColor(.yellow)
                    
                    Text("No Score Yet")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Play \(gameName) to create the first record")
                        .foregroundColor(.gray)
                }
            }else{
                ScrollView{
                    
                    VStack(spacing: 16){
                        
                        Text("🏆 LEADERBOARD")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors:[.neonBlue,
                                            .neonPurple,
                                            .neonPink
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                    
                                )
                            )
                        
                        
                        if let champion = champion {
                            VStack(spacing: 8){
                                Label("ARCADE CHAMPION",
                                systemImage: "crown.fill"
                                )
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                                
                                Text(champion.playerName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("\(champion.totalScore) Points")
                                    .foregroundColor(.neonBlue)
                                    .font(.caption)
                            }
                            .glassCard()
                        }
                        
                        
                        ForEach (
                            Array(
                                scores.enumerated()
                            ),
                            id: \.element.id
                        )
                        {
                            index, score in
                            HStack {
                                
                                Text (
                                    index == 0 ? "🥇" :
                                        index == 1 ? "🥈" :
                                        index == 2 ? "🥉" :
                                        "\(index + 1)"
                                    
                                ).fontWeight(.bold)
                                    .foregroundColor(
                                        index == 0 ? .yellow :
                                            index == 1 ? .white :
                                            index == 2 ? .orange :
                                                .neonBlue
                                        
                                    )
                                
                                Text (
                                    score.playerName
                                ).foregroundColor(.white)
                                
                                Spacer ()
                                
                                Text("\(score.score)"
                                ).foregroundColor(.neonGreen)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .glassCard()
                            
                        }
                    }
                    .padding()
                }
                
            }
        }
        .navigationTitle(gameName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LeaderboardView(
            gameName: "Tap Frenzy"
        )
    }
}
