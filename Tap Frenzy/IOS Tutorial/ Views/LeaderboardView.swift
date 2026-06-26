//
//  LeaderboardView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI



struct LeaderboardView: View {
    
   
    private let manager = LeaderboardManager.shared
    
    private var champion: LeaderboardManager.PlayerStatus?{
        manager.arcadeChampion()
    }
    
    private var games :[String]{
        manager.allGameNames()
    }
    
    private func gameIcon (for game:String) -> String {
        switch game {
        case "Tap Frenzy" :
            return "bolt.fill"
        case "Light It Up" :
            return "lightbulb.max.fill"
        default:
            return "gamecontroller.fill"
        }
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
            
            if games.isEmpty {
                VStack(spacing: 20){
                    Image(systemName: "trophy.fill")
                        .font(.system(size:80))
                        .foregroundColor(.yellow)
                    
                    Text("No Score Yet")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Play a game to create the first record")
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
                        
                        
                        ForEach (games,id: \.self) { game in
                            VStack(alignment: .leading, spacing:12){
                                Label (game,
                                      systemImage: gameIcon (for: game)
                                       )
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.neonBlue)
                                
                                ForEach(
                                    Array(manager.topScores(for:game).enumerated()),
                                    id: \.element.id
                                ){
                                    index,score in
                                    
                                    HStack{
                                        Text(
                                            index == 0 ? "🥇" :
                                                index == 1 ? "🥈" :
                                                index == 2 ? "🥉" :
                                                "\(index+1)"
                                        )
                                        
                                        Text(score.playerName)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("\(score.score)")
                                            .foregroundColor(.neonGreen)
                                            .fontWeight(.bold)
                                            
                                    }
                                    .padding(10)
                                    .glassCard()
                                }
                            }
                            .padding(.bottom,12)
                        }
                            
                    }
                    .padding()
                }
                
            }
        }
        .navigationTitle("Leaderboards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LeaderboardView()
    }
}
