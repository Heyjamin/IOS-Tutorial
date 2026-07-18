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
                            Text(Const.barchart + " " + Const.txtStats.uppercased())
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
                                    title: Const.txtGames.uppercased(),
                                    value: "\(viewModel.totalGames)",
                                    color: .cyan,
                                    icon: Const.gameControllerIcon
                                )
                                StatCard(
                                    title: Const.txtTotal.uppercased(),
                                    value: "\(viewModel.totalScore)",
                                    color: .neonGreen,
                                    icon: Const.sumIcon
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
            .navigationTitle(Const.txtStats)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.reload()
                AudioManager.shared.playMusic(.menu)
            }
        }
    }
    
    private var emptyState: some View{
        VStack(spacing: 16){
            Image(systemName: Const.chartBarIcon)
                .font(.system(size: 70))
                .foregroundColor(.neonBlue)
            Text(Const.txtNoStatsYet)
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(Const.txtNoStatsMsg)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var personalBestsSection: some View{
        VStack(alignment: .leading, spacing: 12){
            Text(Const.txtPersonalBests)
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(GameMode.allCases){ mode in
                HStack{
                    Label(mode.title.capitalized, systemImage: mode.icon)
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
            Text(Const.txtScoresBySession)
                .font(.headline)
                .foregroundColor(.white)
            
            Chart(viewModel.sessions.reversed()){ session in
                BarMark(
                    x: .value(Const.txtGames, session.mode.title),
                    y: .value(Const.txtScore, session.score),
                )
                .foregroundStyle(by: .value(Const.txtMode, session.mode.rawValue))
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
            Text(Const.txtRecentGames)
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(viewModel.recentSessions) { session in
                HStack{
                    Image(systemName: session.mode.icon)
                        .foregroundColor(.neonBlue)
                    VStack(alignment: .leading) {
                        Text(session.mode.title.capitalized)
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
