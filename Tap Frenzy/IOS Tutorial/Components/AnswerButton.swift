//
//  AnswerButton.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct AnswerButton: View {
    let title:String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth:.infinity, minHeight: 60)
                .padding(.horizontal)
        }
        .glassCard()
    }
}

#Preview{
    ZStack{
        Color.black.ignoresSafeArea()
        
        AnswerButton(title: "Tim Berners-Lee") {
            
        }
        .padding()
    }
}
