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
        Button(action:action){
            VStack(spacing:12){
                Image(systemName: game.icon)
                    .font(.system(size:30))
                    .foregroundStyle(color)
                
                Text(game.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(game.subtitle)
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height:120)
            .glassCard()
        }
    }
    
    private var color: Color{
        switch game.colorName{
        case "yellow":
            return .yellow
            
        case "blue":
            return .neonBlue
            
        case "purple":
            return .neonPurple
            
        case "green":
            return .green
            
        default:
            return .white
            
        }
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        
        GameCard(
            game: GameInfo(title: "Quiz Rush", subtitle: "Live Trivia", icon: "questionmark.circle.fill", colorName: "purple", destination: .quizRush
            )
        ){
            
        }
        .padding()
    }
}
