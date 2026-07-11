//
//  StatusTab.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI
import Charts

struct StatsTab: View {
    @StateObject private var viewModel = StatsVM()
    
    var body: some View {
        NavigationStack {
            ZStack{
                NeonAnimatedBackground(style: .calm)
                
                if viewModel.sessions.isEmpty {
                    emptyState
                }else{
                    ScrollView{
                        VStack(spacing: 20){
                            Text("📊 STATS")
                                .font(.system(size: 30, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.neonBlue, .neonPurple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                )
                            )
                            
                            HStack(spacing: 12){
                                StatCard(
                                    title: "GAMES",
                                    value: "\(viewModel.totalGames)",
                                    color: .cyan,
                                    icon: "gamecontroller.fill"
                                )
                                StatCard(
                                    title: "TOTAL",
                                    value: "\(viewModel.totalScore)",
                                    color: .neonGreen,
                                    icon: "sum"
                                )
                            }
                            .glassCard()
                            
                            personalBestsSection
                            chartSection
                            recentSection
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.reload()
                AudioManager.shared.playMusic(.menu)
            }
        }
    }
    
    private var emptyState: some View{
        VStack(spacing: 16){
            Image(systemName: "chart.bar")
                .font(.system(size: 70))
                .foregroundColor(.neonBlue)
            Text("No Stats Yet")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("Complete a game to see your stats here")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var personalBestsSection: some View{
        VStack(alignment: .leading, spacing: 12){
            Text("Personal Bests")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(GameMode.allCases){ mode in
                HStack{
                    Label(mode.rawValue, systemImage: mode.icon)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(viewModel.bestScore(for: mode))")
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
                .padding(10)
                .glassCard()
            }
        }
    }
    
    private var chartSection: some View{
        VStack(alignment: .leading, spacing: 12){
            Text("Scores by Session")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart(viewModel.sessions.reversed()){ session in
                BarMark(
                    x: .value("Game", session.mode.rawValue),
                    y: .value("Score", session.score),
                )
                .foregroundStyle(by: .value("Mode", session.mode.rawValue))
            }
            .frame(height: 220)
            .chartForegroundStyleScale([
                GameMode.tapFrenzy.rawValue: Color.yellow,
                GameMode.lightItUp.rawValue: Color.neonBlue,
                GameMode.quizRush.rawValue: Color.neonPurple,
            ])
            .glassCard()
        }
    }
    
    private var recentSection: some View{
        VStack(alignment: .leading, spacing: 12){
            Text("Recent Games")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(viewModel.recentSessions) { session in
                HStack{
                    Image(systemName: session.mode.icon)
                        .foregroundColor(.neonBlue)
                    VStack(alignment: .leading) {
                        Text(session.mode.rawValue)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Text(session.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(session.score)")
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                }
                .padding(10)
                .glassCard()
            }
        }
    }
}

#Preview {
    StatsTab()
}
