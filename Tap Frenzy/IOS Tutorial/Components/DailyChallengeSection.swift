//
//  DailyChallengeSection.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI

enum DailyChallengeSectionStyle {
    case full
    case compact
}

struct DailyChallengeSection: View {
    var style: DailyChallengeSectionStyle = .full
    
    @ObservableObject private var challenges = DailyChalllengeManager.shared
    
    var body: some View {
        
        switch style {
        case .full:
            fullSection
        case .compact:
            compactSection
        }
    }
    
    private var fullSection: some View {
        
        VStack(alignment: .leading, spacing: 14){
            HStack{
                Label("Daily Challenges",systemImage: "calendar.badge.clock")
                    .font(.headline.bold())
                    .foregroundColor(.yellow)
                
                Spacer()
                
                HStack(spacing: 4){
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(challenges.masterStreak)d")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .font(.caption)
                .padding(.horizontal,10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.1)))
            }
            
            Text("\(challenges.completedCountToday)/3 completed today")
                .font(.caption)
                .foregroundColor(.gray)
            
            ForEach(GameMode.allCases){ mode in
                DailyChalleneRow(mode: mode, record: challenges.record(for:mode))
            }
            
            if challenges.allCompletedToday{
                HStack{
                    Image(systemName: "star.circle.fill")
                        .forgroundColor(.yellow)
                    Text("all daily challenges colpleted! 🎉")
                        .font(.caption.bold())
                        .foregroundColor(.neonGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .glassCard()
            }
        }
        .padding()
        .glassCard()
        .onAppear{
            challenges.refreshForToday()
        }
    }
    
    
    private var compactSection: some View {
        
        VStack(alignment: .leading, spacing: 10){
            sectionHeader
            
            HStack(spacing: 8){
                ForEach(GameMode.allCases) { mode in compactChalleneTitle(mode: mode, record: challenges.record(for:mode))
                }
            }
            
            if challenges.allColpletedToday {
                completionBanner
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay{
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
        .onAppear {
            challenges.refreshForToday()
        }
    }

    private var sectionHeader : some View {
        HStack{
            Label("Daily Challenges", systemImage: "calendar.badge.colck")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.yellow)
            
            Spacer()
            
            HStack(spacing: 4){
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                text("\(challenges.masterStreak)d")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.white.opacity(0.1)))
        }
    }
    
    private var completionBanner: some View {
        HStack(spaceing: 6){
            Image(systemName: "star.circle.fill")
                .foregroundColor(.yellow)
            Text("All complete today! 🎉")
                .font(.caption2.weight(.bold))
                .foregroundColor(.neonGreen)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.05)))
    }
    
    private func compactChallengeTitle(mode: GameMode, record: GameDailyChallenge) -> some View{
        let progress = record.targetScore > 0
        ? min(Double(record.todayBestScore)/Double(record.targetScore), 1.0)
        : 0
        
        return VStack(spacing: 6){
            Image(systemName: mode.icon)
                .font(.caption)
                .foregroundColor(titleColor(for: mode))
            
            ProgressView(value: progress)
                .tint(record.completedToday ? .neonGreen : titleColor(for: mode))
                .scaleEffect(x: 1, : 0.7, anchor: .center)
            
            if record.completedToday{
                Image(systemName: "checkmark")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }

    private func titleColor(for mode: GameMode) -> color {
        switch mode{
        case .tapFrenzy: return .yellow
        case .lightItUp: return .neonBlue
        case .quizRush: return .neonPurple
        }
    }
}


struct DailyChallengeRow: View{
    let mode: GameMode
    let record: GameDailyChallenge
    
    private var progress: Double{
        guard record.targetScore > 0 else {return 0 }
        return min(Double(record.todayBestScore) / Double(record.targetScore), 1.0)
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Image(systemName: mode.icon)
                    .foregroundColor(rowColor)
                    .frame(width: 24)
                
                Text(mode.rawValue)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                if record.completedToday{
                    Label ("Done", systemImage: "checkmark.seal.fill")
                        .font(.caption.bold())
                        .foregroundColor(.neonGreen)
                }else{
                    Text("\(record.todayBestScore)/\(record.targetScore)")
                        .font(.caption.monospacedDigit())
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 2){
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                    Text("\(record.streak)")
                        .font(.caption.bold())
                }
                .foregroundColor(record.streak > 0 ? .orange : gray)
            }
            
            ProgressView(value: progress)
                .tint(record.completedToday ? .neonGreen : rowColor)
            
            if !record.completedToday {
                Tex("Score \(record.targetScore)+ to keep your streak")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .pading(10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private var rowColor : Color {
        switch mode{
        case .tapFrenzy: return .yellow
        case .lightItUp: return .neonBlue
        case .quizRush: return .neonPurple
        }
    }
}

#Preview("compact"){
    ZStack{
        Color.black.ignoresSafeArea()
        DailyChallengeSection(style: .compact)
            .padding()
    }
}

#Preview("Full"){
    ZStack{
        Color.black.ignoresSafeArea()
        DailyChallengeSection(style: .full)
            .padding()
    }
}
