//
//  HomeTab.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct HomeTab: View {
    @AppStorage(Const.txtCurrentPlayer)
    private var playerName = ""
    
    @ObservedObject private var navigation = AppNavigationStore.shared
    @State private var selectedGame: GameDestination?
    
    private var games: [GameInfo]{
        GameMode.allCases.map { mode in
            GameInfo(
                title: mode.rawValue,
                subtitle: mode.subtitle,
                icon: mode.icon,
                colorName: mode.colorName,
                destination: mode.destination
            )
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                NeonAnimatedBackground(style: .menu)
                
                ScrollView(showsIndicators: false){
                    
                    VStack(spacing: 16){
                        homeHeader
                        gamesSection
                        DailyChallengeSection()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
                .navigationBarHidden(true)
                .navigationDestination(item: $selectedGame){ destination in
                    switch destination{
                    case .levelSelect(let mode):
                        LevelSelectView(mode: mode)
                    case .tapFrenzy:
                        LevelSelectView(mode: .tapFrenzy)
                    case .lightItUp:
                        LevelSelectView(mode: .lightItUp)
                    case .quizRush:
                        LevelSelectView(mode: .quizRush)
                    }
                }
                .onAppear{
                    AudioManager.shared.playMusic(.menu)
                    DailyChallengeManager.shared.refreshForToday()
                }
                .onChange(of: navigation.homeResetToken) {_, _ in
                    selectedGame = nil
                }
            }
        }
    
    private var homeHeader: some View {
        HStack(alignment: .center, spacing: 12){
            VStack(alignment: .leading, spacing: 2){
                Text(Const.txtNeonArcade)
                    .font(.system(size:22, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors:[.neonBlue,.neonPurple, .neonPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("\(Const.txtReadyToPlay) \(playerName)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
            }
                Spacer(minLength: 8)
                
            Image(systemName: Const.gameControllerIcon)
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(colors: [.neonBlue, .neonPurple], startPoint: .top, endPoint: .bottom)
                    )
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.08)))
            }
            .padding(.horizontal, 4)
        }
        
    private var gamesSection: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text(Const.txtArcadeGames)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                Text("\(games.count) \(Const.txtGames)" )
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.white.opacity(0.45))
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 10){
                ForEach(games){ game in
                    GameCard(game: game){
                        selectedGame = game.destination
                    }
                }
            }
        }
    }
}

#Preview {
    HomeTab()
}

