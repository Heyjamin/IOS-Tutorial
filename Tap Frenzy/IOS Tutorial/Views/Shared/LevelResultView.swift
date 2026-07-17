//
//  LevelResultView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct LevelResultView: View {
    let mode: GameMode
    let stageLevel: Int
    let score: Int
    let starsEarned: Int
    let headline: String
    let subtitle: String?
    let bestScore: Int?
    let isNewRecord: Bool
    let onPlayAgain: () -> Void
    let onNextLevel: (() -> Void)?
    
    private var config: GameLevelConfig {
        GameLevelConfig.config(mode: mode, level: stageLevel)
    }
    
    private var shareData: ScoreShareData{
        ScoreShareData(
            mode: mode,
            score: score,
            headline: headline,
            stageLevel: stageLevel,
            starsEarned: starsEarned,
            worldTitle: config.world.title,
            subtitle: subtitle
            )
    }
    
    private var canAdvance: Bool {
        starsEarned >=  GameLevelConfig.unlockStarsRequired
        && stageLevel < GameLevelConfig.levelsPerGame(for: mode)
        && LevelProgressStore.shared.isUnlocked(mode: mode, level: stageLevel + 1)
    }
    
    var body: some View {
        ZStack {
            LevelWorldBackground(world: config.world)
            
            VStack(spacing: 0) {
                GameHUDBar(guideMode: mode)
                    .padding(.horizontal, 16)
                    .padding(.top,4)
                    .padding(.bottom, 6)
                
                ScrollView(showsIndicators: false){
                    VStack(spacing: 14){
                        resultHeader
                        scoreCard
                        statusHint
                        DailyChallengeResultBadge(mode: mode, score: score)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                
                bottomActions
                
                GameTabBar()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var resultHeader: some View {
        VStack(spacing: 8){
            Image(systemName: starsEarned >= 3 ? Const.starCircleIcon:Const.flagIcon)
                .font(.system(size: 52))
                .foregroundColor(starsEarned >= 3 ? .yellow : .neonBlue)
            
            Text(headline)
                .font(.title2.weight(.black))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("\(config.world.title) . L\(stageLevel) . \(config.difficulty.rawValue)")
                .font(.caption)
                .foregroundColor(config.difficulty.color)
            
            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private var scoreCard: some View {
        VStack(spacing: 6){
            Text(Const.txtStarsEarned)
                .font(.caption2.weight(.bold))
                .foregroundColor(.gray)
            StarRatingView(stars: starsEarned, size:24)
            Text("\(score) " + Const.txtPoints.capitalized)
                .font(.title3.weight(.bold))
                .foregroundColor(.neonGreen)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.07))
        )
        .overlay{
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private var statusHint: some View {
        if starsEarned < GameLevelConfig.unlockStarsRequired {
            Text(Const.txtScore.capitalized + " \(config.starThresholds[1]) " + Const.txtStarsToUnlock)
                .font(.caption2)
                .foregroundColor(.neonRed)
                .multilineTextAlignment(.center)
        }else if canAdvance{
            Text(Const.txtNextLevelUnlocked)
                .font(.caption2.weight(.bold))
                .foregroundColor(.neonGreen)
                .multilineTextAlignment(.center)
        }
    }
    
    private var bottomActions: some View {
        VStack(spacing: 8) {
            if canAdvance, let onNextLevel {
                ResultActionButton(title: Const.txtNextLevel, icon: Const.arrowRightCircleIcon, style: .primary){
                    onNextLevel()
                }
            }
            
            HStack (spacing: 10){
                ShareScoreButton(data: shareData, compact: true)
                ResultActionButton(title: Const.txtPlayAgain, icon: Const.arrowClockwiseIcon, style: .secondary){
                    onPlayAgain()
                }
            }
        }
        .padding(.horizontal,16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial.opacity(0.85))
    }
    
}

#Preview {
    LevelResultView(
        mode: .tapFrenzy,
        stageLevel: 1,
        score: 25,
        starsEarned: 3,
        headline: Const.txtLevelComplete,
        subtitle: nil,
        bestScore: 30,
        isNewRecord: false,
        onPlayAgain: {},
        onNextLevel: {}
    )
}
