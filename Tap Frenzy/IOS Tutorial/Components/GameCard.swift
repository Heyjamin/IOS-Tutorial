//
//  GameCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI

struct GameCard: View {
    let game: GameInfo
    let action: () -> Void
    
    var body: some View {
        Button{
            AudioManager.shared.playSFX(.card)
            action()
        } label: {
            HStack(spacing: 14){
                ZStack{
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(0.35), accentColor.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width:48, height:48)
                    Image(systemName:game.icon)
                        .font(.system(size:20,weight: .semibold))
                        .foregroundStyle(accentColor)
                }
                
                VStack(alignment: .leading, spacing: 3){
                    Text(game.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Text(game.subtitle)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
                
                Spacer(minLength: 4)
                
                Image(systemName: "play.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(10)
                    .background(Circle().fill(accentColor.opacity(0.85)))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius:16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.09), Color.white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(alignment: .leading){
                RoundedRectangle(cornerRadius:16, style: .continuous)
                    .fill(accentColor)
                    .frame(width: 3)
                    .padding(.vertical, 10)
            }
            .overlay{
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var accentColor: Color{
        switch game.colorName{
        case "yellow":
            return .yellow
            
        case "blue":
            return .neonBlue
            
        case "purple":
            return .neonPurple
            
        case "green":
            return .neonGreen
            
        default:
            return .white
            
        }
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        VStack(spacing: 10){
            GameCard(
                game: GameInfo(title: "Tap Frenzy", subtitle: "Speed challenge", icon: "bolt.fill", colorName: "yellow", destination: .tapFrenzy
            )
        ){}
        
        GameCard(
            game: GameInfo(title: "Quiz Rush", subtitle: "Live Trivia", icon: "questionmark.circle.fill", colorName: "purple", destination: .quizRush
                          )
        ){}
    }
    .padding()
    }
}
