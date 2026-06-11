//
//  ContentView.swift
//  IOS Tutorial
//
//  Created by student5 on 2026-06-06.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    
    @State private var timeRemaining = 10_000
    
    @State private var gameOver = false
    
    @State private var timerStarted  = false
    
    // Format time
    var formattedTime: String {
        let minutes = timeRemaining / 60000
        let seconds = (timeRemaining%60000)/1000
        let milliseconds = (timeRemaining%1000)/10
        
        return String(
            format: "%02d:%02d:%02d",
            minutes,
            seconds,
            milliseconds
            )
        
    }
    
    // Timer function
    func startTimer() {
        guard !gameOver else { return }
        
        timerStarted = true
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 10
            } else {
                timer.invalidate()
                gameOver = true
            }
            
        }
    }
    
    // Game reset function
    func resetGame() {
        score = 0
        timeRemaining = 10_000
        gameOver = false
        timerStarted = false
    }
    
    var body: some View {
        
        VStack (spacing:30){
            
            Text("Timer : \(formattedTime)")
            .font(.system(size: 40, weight: .bold))
            
            
            //change text with button
            Button{
                score += 1
                if !timerStarted{
                    startTimer()
                }
            }
            label: {
                Text("Touch Me")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .font(.system(size: 30, weight: .bold))
            }
            .disabled(gameOver)
            
            // Showing score
            Text ("Score : \(score)")
                .font(.system(size: 40, weight: .bold))
            
        }
        .padding()
        .alert("Game Over", isPresented: $gameOver){
            Button("ok"){
                resetGame()
            }
        }message: {
            Text("Your final score is \(score)")
        }
        
    }
}

#Preview {
    ContentView()
}
