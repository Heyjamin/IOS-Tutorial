//
//  DailyChallengeResultBadge.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI

struct DailyChallengeResultBadge: View {
    let mode: GameMode
    let score: Int
    
    @ObservedObject private var challenges = DailyChallengeManager.shared
    
    private var record: GameDailyChallenge {
        challenges.record(for: mode)
    }
    
    var body: some View {
        let metTarget = score >= record.targetScore
        
        HStack(spacing: 8){
            Image(systemName: metTarget ? Const.checkmarkIcon : Const.xmarkIcon)
                .foregroundColor(metTarget ? .neonGreen : .neonRed)
            
            VStack(alignment: .leading, spacing: 2){
                Text("\(Const.txtDailyChallenge)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                
                if metTarget{
                    Text("\(Const.txtTarget) \(record.targetScore) \(Const.txtReachedStreak) \(record.streak) \(Const.flame)")
                        .foregroundColor(.neonGreen)
                }else{
                    Text("\(Const.txtNeeded) \(record.targetScore) \(Const.txtPtsHortBy) \(max(0, record.targetScore - score))")
                        .font(.caption2)
                        .foregroundColor(.neonGreen)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill((metTarget ? Color.neonGreen : Color.neonRed).opacity(0.12))
                
        )
    }
}


#Preview {
    DailyChallengeResultBadge(mode: .tapFrenzy, score: 25)
        .padding()
        .background(Color.black)
}
