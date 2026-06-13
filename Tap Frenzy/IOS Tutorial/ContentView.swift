//
//  ContentView.swift
//  IOS Tutorial
//
//  Created by Nuwan Jeewantha COBSCCOMP251P-045.
//

import SwiftUI

struct ContentView: View {
    
    //Challenge 01 States
    @State private var comboMultiplier = 1
    @State private var lastTapTime = Date()
    @State private var comboText = ""
    
    //Challenge 02 States
    @State private var buttonColor: Color = .orange
    @State private var colorTimer: Timer?
    
    // States
    @State private var score = 0
    
    @State private var highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
    
    @State private var isNewRecord = false
    
    @State private var timeRemaining = 10_000
    
    @State private var gameOver = false
    
    @State private var timerStarted  = false
    
    @State private var showToast = false
    
    @State private var toastMessage = ""
    
    
    // Timer Format
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
    
    //Color Change function
    func startColorCycle() {
        colorTimer?.invalidate()
        
        colorTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            
            let colors: [Color] = [.orange, .green, .gray]
            
            buttonColor = colors.randomElement() ?? .orange
        }
    }
    
    // Timer function
    func startTimer() {
        guard !timerStarted else { return }
        
        timerStarted = true
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 10
            } else {
                // Game over validation
                timer.invalidate()
                
                //Stop Color Changeing
                colorTimer?.invalidate()
                
                gameOver = true
                
                //High score record keeping
                if score > highestScore {
                    highestScore = score
                    UserDefaults.standard.set(highestScore, forKey: "HighestScore")
                    isNewRecord = true
                }else{
                    isNewRecord = false
                }
                
                //Game over toast
                toastMessage = "Game Over! Score: \(score)"
                showToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
            
        }
    }
    
    // Reset game function
    func resetGame() {
        score = 0
        timeRemaining = 10_000
        gameOver = false
        timerStarted = false
        
        comboMultiplier = 1
        lastTapTime = Date()
        
        isNewRecord = false
        
        buttonColor = .orange
    }
    
    func handleTap(){
        let now = Date()
        
        let timeDifference = now.timeIntervalSince(lastTapTime)
        
        //Combo System
        if timeDifference <= 0.5{
            comboMultiplier = min(comboMultiplier + 1,10)
            
        }else{
            comboMultiplier = 1
        }
        
        lastTapTime = now
        
        var points = comboMultiplier
        
        if buttonColor == .green{
            points += 2 // Bonus Point 2
            toastMessage = "BONUS! +\(points)"
        }else if buttonColor == .gray{
            points = -comboMultiplier // penalty rediuse points
            toastMessage = "PENALTY! +\(points)"
        }
        score += points
        
        if score < 0 {
            score = 0
        }
    }
    
    var body: some View {
 
            if gameOver{

                // Game over screen
                VStack (spacing:20){
                    
                    Image(systemName: isNewRecord ? "trophy.fill":"xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(isNewRecord ? .yellow : .red)
                    
                    Text (isNewRecord ? "WINNER!":"GAME OVER")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your Score")
                        .font(.title2)
                    
                    Text("\(score)")
                        .font(.system(size:60, weight:.bold))
                    
                    Text("Highest Score: \(highestScore)")
                        .font(.title2)
                    
                    Button("Play Again"){
                        resetGame()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        isNewRecord ? Color.green.opacity(0.2) : .red.opacity(0.15)
                    )
            }else{
                
                //Game Screen
                VStack(spacing: 40) {
                    
                    //Title
                    Text("Tap Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Highest Score: \(highestScore)")
                        .font(.title2)
                    
                    // Showing score
                    Text ("Score : \(score)")
                        .font(.system(size: 40, weight: .bold))
                    
                    Text(
                        buttonColor == .green ? "BONUS":
                            buttonColor == .gray ? "PENALTY": "NORMAL"
                    ).font(.title3)
                        .fontWeight(.bold)
                        
                    //TAP Buton
                    Button{
                        handleTap()
                        if !timerStarted{
                            startTimer()
                            startColorCycle()  //Button Color Change Start
                        }
                    } label: {
                        Text("TAP")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 220, height: 220)
                            .background(buttonColor)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }
                    
                    //Timer
                    Text("Timer : \(formattedTime)")
                        .font(.system(size: 35, weight: .bold))
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.15))
             
                .onDisappear {
                    colorTimer?.invalidate()
                }
                
                    VStack{
                        Text("Combo \(comboMultiplier)")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                            .fontWeight(.bold)
                    }
                    .padding()
                }
                Spacer()
           
                
            
        }
       
}
#Preview {
    ContentView()
}
