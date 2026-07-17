//
//  ResultView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let headline: String
    let subtitle: String?
    let bestScore: Int?
    let isNewRecord: Bool
    let onPlayAgain: () -> Void
    
    var body: some View{
        ZStack{
            NeonAnimatedBackground(style: .game)
            
            VStack(spacing: 0){
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16){
                        Image(systemName: isNewRecord ? Const.trophyIcon : Const.flagIcon)
                            .font(.system(size: 56))
                            .foregroundColor(isNewRecord ? .yellow : .neonBlue)
                        
                        Text(headline)
                            .font(.title.weight(.black))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        if let subtitle{
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        ScoreBadge (title: Const.txtFinalScore, score:score, color: .neonGreen)
                        
                        if let bestScore, bestScore > 0 {
                            Text(Const.txtBest + " \(bestScore)")
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.yellow)
                        }
                        DailyChallengeResultBadge(mode: mode, score: score)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                HStack(spacing: 10){
                    ShareScoreButton(
                    data: ScoreShareData(
                        mode: mode,
                        score: score,
                        headline: headline,
                        stageLevel: nil,
                        starsEarned: nil,
                        worldTitle: nil,
                        subtitle: subtitle
                    ),
                    compact: true
                    )
                    ResultActionButton(title: Const.txtPlayAgain, icon: Const.arrowClockwiseIcon, style: .secondary){
                        onPlayAgain()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial.opacity(0.85))
            }
        }
        .gameAudioControls()
    }
}

#Preview{
    ResultView(
        mode: .tapFrenzy,
        score: 47,
        headline: Const.txtGameOver,
        subtitle: Const.txtNiceRun,
        bestScore: 52,
        isNewRecord: false,
        onPlayAgain: {})
}
