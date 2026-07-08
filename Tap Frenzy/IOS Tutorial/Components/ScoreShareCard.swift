//
//  ScoreShareCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI
import UIKit

struct ScoreShareData{
    let mode: GameMode
    let score: Int
    let headline: String
    let stageLevel: Int?
    let starsEarned: Int?
    let worldTitle: String?
    let subtitle: String?
    
    var shareCaption: String{
        if let stageLevel, let starsEarned {
            return "I earned \(starsEarned)* on \(mode.rawValue) level \(stageLevel) with \(score) pts in Neon Archade! 🎮"
        }
        return " I scored \(score) on \(mode.rawValue) in Neon Archade! 🎮"
    }
}

struct ScoreShareCardView: View {
    
    let data: ScoreShareData
    
    private var accent: Color{
        switch data.mode{
        case .tapFrenzy: return .yellow
        case .lightItUp: return .neonBlue
        case .quizRush: return .neonPurple
        }
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.05, green: 0.05, blue: 0.10)
            
            LinearGradient(
                colors: [
                    accent.opacity(0.18),
                    Color(red: 0.03, green: 0.05, blue: 0.12),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0){
                Text("NEON ARCADE")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors:[.neonBlue, .neonPurple], startPoint: .leading, endPoint: .trailing)
                    )
                    .tracking(2)
                    .padding(.top, 32)
                
                Spacer().frame(height: 20)
                
                ZStack{
                    
                    Circle()
                        .fill(accent.opacity(0.2))
                        .frame(width: 88, height: 88)
                    Image(systemName: data.mode.icon)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(accent)
                }
                
                Spacer().frame(height: 14)
                
                Text(data.mode.rawValue)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                if let stageLevel = data.stageLevel{
                    Text("Level \(stageLevel)" + (data.worldTitle.map { " . \($0)"} ?? ""))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.65))
                        .padding(.top, 4)
                }
                
                Spacer().frame(height: 16)
                
                Text(data.headline.uppercased())
                    .font(.caption2.bold())
                    .foregroundColor(accent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(accent.opacity(0.18)))
                
                Spacer().frame(height: 18)
                
                Text("\(data.score)")
                    .font(.system(size:64, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                
                Text("POINTS")
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.45))
                    .tracking(2)
                    .padding(.top, 2)
                
                if let stars = data.starsEarned{
                    StarRatingView(stars: stars, size: 22)
                        .padding(.top, 14)
                }
                
                if let subtitle = data.subtitle, !subtitle.isEmpty{
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 24)
                        .padding(.top,10)
                }
                
                Spacer()
                
                Text("Neon Arcade . iOS")
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.bottom, 28)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 400, height: 500)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay{
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(account.opacity(0.45), lineWidth: 2)
        }
        .preferredColorScheme(.dark)
    }
    
    ================================
}
