//
//  QuizResultView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct QuizResultView: View {
    
    let score: Int
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [.bgTop, .black,.bgBottom],
                startPoint: .top,
                endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack (spacing: 30) {
            Text("🎉")
                .font(.system(size:80))
            
            Text("Quiz Complete")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
            Text("Final Score")
                .foregroundStyle(.gray)
            
            Text("\(score)")
                .font(.system(size:60, weight: .bold))
                .foregroundStyle(.green)
            
            Button {
                dismiss()
            } label: {
                Text("Back to Arcade")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .glassCard()
        }
        
        .padding()
    }

}
}


#Preview {
    QuizResultView(score: 82)
}

