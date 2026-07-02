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
    
    let action: () -> Void
    
    private var backgroundColor: Color {
        
        guard isSelected else {
            return Color.white.opacity(0.08)
        }
        
        return isCorrect == true ? .green : .red
    }
    
    var body: some View {
        
        Button(action: action) {
            
            Text(title.htmlDecoded)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth:.infinity)
                .padding()
                .frame(height: 60)
                .shadow(
                    color: isSelected
                    ? (isCorrect == true ? .green : .red)
                    : .clear,
                    radius: 15
                )
            
        }
        .background(RoundedRectangle(cornerRadius: 18).fill(backgroundColor)
        )
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .animation(.easeInOut(duration:0.25), value:backgroundColor)

    }
}

#Preview{
    ZStack{
        Color.black.ignoresSafeArea()
        
        AnswerButton(
            title: "Tim Berners-Lee",
            isSelected: true,
            isCorrect: true) {
            
        }
        .padding()
    }
}
