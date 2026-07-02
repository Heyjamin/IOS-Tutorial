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
    
    private var background: Color {
        guard isSelected else {
            return Color.white.opacity(0.08)
        }
        
        return isCorrect == true ? .green : .red
    }
    
    var body: some View {
        
        Button(action: action) {
            
            Text(title.htmlDecoded)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth:.infinity)
                .padding()
        }
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .animation(.easeInOut(duration: 0.25),value: background)
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
