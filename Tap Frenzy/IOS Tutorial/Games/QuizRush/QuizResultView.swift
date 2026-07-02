//
//  QuizResultView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI


struct QuizResultView: View {
    
    let score: Int
    let onPlayAgain: () -> Void
    
    private var message: String {
        switch score{
        case 90...:
            return "🏆 Trivia Master!"
            
        case 70...:
            return "🎉 Excellent!"
            
        case 50...:
            return "🎈 Well Done!"
            
        default:
            return "💪 Keep Practicing!"
        }
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [.bgTop, .black,.bgBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack (spacing: 30) {
                Text(message)
                    .font(.title3)
                    .foregroundStyle(.yellow)
                
                Text("Quiz Complete")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text("Final Score")
                    .foregroundStyle(.gray)
                
                Text("\(score)")
                    .font(.system(size:60, weight: .bold))
                    .foregroundStyle(.green)
                
                Button{
                    onPlayAgain()
                } label: {
                    Text("Play Again")
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
    QuizResultView(score: 60){
        print("Play Again")
    }
}

