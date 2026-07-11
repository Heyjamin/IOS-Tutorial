//
//  AnswerButton.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct AnswerButton: View {
    
    let title:String
    
    let isSelected: Bool
    
    let isCorrect: Bool?
    
    let correctAnswer: String?
    
    var compact:Bool = false
    
    let action: () -> Void
    
   private var decodedTitle: String {
        title.htmlDecoded
    }
    
    private var backgroundColor: Color {
        if let correctAnswer{
            let decodedCorrect = correctAnswer.htmlDecoded
            if decodedTitle == decodedCorrect {
                return .green
            }
            if isSelected {
                return isCorrect == true ? .green : .red
            }
        }
        return .white.opacity(0.08)
    }
    
    var body: some View {
        
        Button(action:{
            AudioManager.shared.playSFX(.button)
            action()
        }){
            
            Text(decodedTitle)
                .font(compact ? .subheadline.weight(.medium) : .headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(compact ? 4 : 3)
                .minimumScaleFactor(0.85)
                .frame(maxWidth:.infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, compact ? 10 :14)
                .frame(minHeight: compact ? 44 : 56)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(backgroundColor)
                        
                    )
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth:1)
                )
            
        }
        .buttonStyle(.plain)

    }
}

#Preview{
    ZStack{
        Color.black.ignoresSafeArea()
        VStack(spacing:10){
            AnswerButton(
                title: "Tim Berners-Lee",
                isSelected: true,
                isCorrect: true,
                correctAnswer: nil,
                compact: true
            ) {}
        }
        .padding()
    }
}
