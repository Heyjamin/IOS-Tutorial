//
//  LevelSelectView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct LevelSelectView: View {
    let mode: GameMode
    
    @ObservedObject private var progress = LevelProgressStore.shared
    @State private var selectedRoute: GameLevelRoute?
    @Environment(\.dismiss) private var dismiss
    
    private var levels: [GameLevelConfig] {
        GameLevelConfig.allLevels(for: mode)
    }
    
    var body: some View {
        ZStack {
            NeonAnimatedBackground(style: .menu)
            
            ScrollView {
                VStack(spacing: 20){
                    VStack(spacing: 6) {
                        Image(systemName: mode.icon)
                            .font(.system(size:40))
                            .foregroundStyle(modeAccent)
                        
                        Text(mode.rawValue)
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.white)
                        
                        Text("Select a Level")
                            .foregroundColor(.gray)
                    }
                    
                    Text("Earn *** (3/5) or more to unlock the next level")
                        .font(.caption)
                        .foregroundColor(.neonBlue)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing:14){
                        ForEach(levels) { config in
                            LevelCard(
                                config:config,
                                isUnlocked: progress.isUnlocked(mode: mode, level: config.number),
                                stars: progress.bestStars(mode:mode, level: config.number)
                            ){
                                selectedRoute = GameLevelRoute(mode: mode, level: config.number)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Levels")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedRoute) { route in
            gameView(for: route)
        }
        .onAppear {
            AudioManager.shared.playMusic(.menu)
        }
    }
    
    private var modeAccent: LinearGradient {
        switch mode{
        case .tapFrenzy:
            return LinearGradient(colors:[.yellow, .orange], startPoint: .leading, endPoint: .trailing)
        case .lightItUp:
            return LinearGradient(colors:[.neonBlue, .cyan], startPoint: .leading, endPoint: .trailing)
        case .quizRush:
            return LinearGradient(colors:[.neonPurple, .neonPink], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    @ViewBuilder
    private func gameView(for route: GameLevelRoute) -> some View {
        switch route.mode {
        case .tapFrenzy:
            TapFrenzyView(stageLevel: route.level)
        case .lightItUp:
            LightItUpView(stageLevel: route.level)
        case .quizRush:
            QuizRushView(stageLevel: route.level)
        }
    }
}

struct LevelCard: View {
    let config: GameLevelConfig
    let isUnlocked: Bool
    let stars: Int
    let action: () -> Void
    
    var body: some View {
        Button {
            guard isUnlocked else { return }
            AudioManager.shared.playSFX(.card)
            action()
        } label: {
            VStack(spacing: 10){
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: isUnlocked
                                ? [config.world.orbColors[0].opacity(0.3), config.world.orbColors[1].opacity(0.15)]
                                : [Color.gray.opacity(0.15), Color.gray.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 80)
                    if isUnlocked {
                        Text(worldEmoji)
                            .font(.system(size:36))
                    }else{
                        Image(systemName:"lock.fill")
                            .font(.system(size:28))
                            .foregroundColor(.gray)
                    }
                }
                
                Text("level \(config.number)")
                    .font(.headline.bold())
                    .foregroundColor(isUnlocked ? .white : .gray)
                
                Text(config.subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Text(config.difficulty.rawValue)
                    .font(.caption2.bold())
                    .foregroundColor(config.difficulty.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(config.difficulty.color.opacity(0.15)))
                
                StarRatingView(stars: stars, size: 12)
                
                if !isUnlocked {
                    Text("Need *** on L\(config.number-1)")
                        .font(.caption2)
                        .foregroundColor(.neonRed)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .glassCard()
            .opacity(isUnlocked ? 1 : 0.75)
        }
        .disabled(!isUnlocked)
        
    }
    
    private var worldEmoji: String {
        switch config.world {
        case .meadow: return "🌾"
        case .ocian: return "🌊"
        case.sunset: return "🌅"
        case .cosmos: return "🌌"
        case .volcano: return "🌋"
        }
    }
    
}

#Preview{
    NavigationStack{
        LevelSelectView(mode: .tapFrenzy)
    }
}
