//
//  DailyChallengeBanner.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI

struct DailyChallengeBanner: View {
    let mode: GameMode
    @ObservedObject private var challenges = DailyChallengeManager.shared
    
    private var record: GameDailyChallenge {
        challenges.record(for: mode)
    }
    
    var body: some View {
        HStack(spacing: 10){
            Image(systemName: record.completedToday ? Const.checkmarkIcon : Const.targetIcon)
                .foregroundColor(record.completedToday ? .neonGreen : .yellow)
            
            VStack(alignment: .leading, spacing: 2){
                Text("\(Const.txtDailyChallenge)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                
                if record.completedToday {
                    Text("\(Const.txtCompleteStrak) \(record.streak) \(Const.txtDays)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if record.streak > 0 {
                Label("\(record.streak)", systemImage: Const.flameIcon)
                    .font(.caption.bold())
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .glassCard()
        .padding(.horizontal)
        .onAppear {
            challenges.refreshForToday()
        }
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        DailyChallengeBanner(mode: .tapFrenzy)
    }
}
