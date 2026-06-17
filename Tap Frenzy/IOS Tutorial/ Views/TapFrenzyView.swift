//
//  ContentView.swift
//  IOS Tutorial
//
//  Created by Nuwan Jeewantha COBSCCOMP251P-045.
//

import SwiftUI

struct TapFrenzyView: View {
    
    //Challenge 01 States
    @State private var comboMultiplier = 1
    @State private var lastTapTime = Date()
    @State private var comboText = ""
    @State private var isComboActive = false
    
    //Challenge 02 States
    @State private var buttonColor: Color = .neonBlue
    @State private var colorTimer: Timer?
    
    //Challenge 03 States
    @State private var buttonOffsetX: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 0
    @State private var moveTimer: Timer?
    
    //Challenge 04 States
    @State private var btnSize = CGFloat(220)
    @State private var btnTextSize = CGFloat(80)
    
    // States
    @State private var score = 0
    
    
  
    
    
    @State private var highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
    
    @State private var isNewRecord = false
    
    @State private var timeRemaining = 10_000
    
    @State private var gameOver = false
    
    @State private var timerStarted  = false
    
    @State private var showToast = false
    
    @State private var toastMessage = ""
    
    @AppStorage ("currentPlayer")
    var playerName = ""
    
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
            
            let colors: [Color] = [.neonBlue, .neonGreen, .neonRed]
            
            buttonColor = colors.randomElement() ?? .orange
        }
    }
    
    // Moving Button
    func startMoving(){
        moveTimer?.invalidate()
        
        moveTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration:0.2)){
                buttonOffsetX = CGFloat.random(in: -100...100)
                buttonOffsetY = CGFloat.random(in: -150...150)
                
            }
        }
    }
    
    // Timer function
    func startTimer() {
        guard !timerStarted else { return }
        
        timerStarted = true
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 10
                
                // Challenge 04 (Srinking Button)
                btnSize = CGFloat(btnSize-20/100)
                btnTextSize = CGFloat(btnTextSize-10/100)
                
                
            } else {
                // Game over validation
                timer.invalidate()
                
                //Stop Color Changeing
                colorTimer?.invalidate()
                
                // Stop Moving
                moveTimer?.invalidate()
                
                gameOver = true
                
                
                if score > 0 {
                    
                    LeaderboardManager.shared.addScore(playerName: playerName, score: score, gameName: "Tap Frenzy")
                }
                
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
        //UserDefaults.standard.set(0, forKey: "HighestScore")
        score = 0
        timeRemaining = 10_000
        gameOver = false
        timerStarted = false
        
        comboMultiplier = 1
        lastTapTime = Date()
        
        isNewRecord = false
        
        buttonColor = .neonBlue
        
        isComboActive = false
        btnSize = CGFloat(220)
        btnTextSize = CGFloat(80)
        
        buttonOffsetX = 0
        buttonOffsetY = 0
        
    }
    
    
    
    func handleTap(){
        let now = Date()
        
        let timeDifference = now.timeIntervalSince(lastTapTime)
        
        //Combo System
        if timeDifference <= 0.5{
            comboMultiplier = min(comboMultiplier + 1,10)
            isComboActive = true
        }else{
            comboMultiplier = 1
        }
        
        lastTapTime = now
        
        var points = comboMultiplier
        
        if buttonColor == .neonGreen{
            points += 2 // Bonus Point 2
            toastMessage = "BONUS! +\(points)"
        }else if buttonColor == .neonRed{
            points = -comboMultiplier // penalty rediuse points
            toastMessage = "PENALTY! +\(points)"
        }
        score += points
        
        if score < 0 {
            score = 0
        }
    }
    
    var body: some View {
        
        ZStack{
            LinearGradient(
                colors:[
                    Color.bgTop,
                    Color.black,
                    Color.bgBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            if gameOver{
                
                // Game over screen
                VStack(spacing:25){
                    Image(systemName: isNewRecord ?
                          "trophy.fill" :
                        "xmark.circle.fill"
                    )
                    .font(.system(size:90))
                    .foregroundColor(
                        isNewRecord ?
                            .yellow :
                                .neonRed
                    )
                    Text (
                        isNewRecord ?
                        "NEW RECORD!" :
                            "GAME OVER"
                    )
                    .font(.system(size:34,weight:.black))
                    .foregroundColor(.white)
                    
                    VStack(spacing:10){
                        Text("SCORE")
                            .foregroundColor(.gray)
                        
                        Text("\(score)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text ("BEST \(highestScore)")
                            .foregroundColor(.yellow)
                    }
                    
                    Button {
                        resetGame()
                    } label:{
                        Text("PLAY AGAIN")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [
                                        .neonBlue,
                                        .purple,
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                            )
                        )
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(30)
                .glassCard()
                .shadow(
                    color: isNewRecord ?
                        .yellow.opacity(0.5) :
                            .neonRed.opacity(0.5),
                    radius: 30
                    
                )
                .padding()
                
            }else{
                VStack(spacing:20){
                    //Title
                    VStack(spacing:4){
                        Text("⚡ TAP FRENZY")
                            .font(.system(size:34,weight: .black))
                        
                        Text ("ARCADE EDITION")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors:[.cyan,.purple,.pink],
                            startPoint:.leading,
                            endPoint: .trailing
                        )
                    )
                    
                    HStack{
                        StatView(
                            title: "SCORE",
                            value: "\(score)",
                            color: .cyan,
                            icon: "star.fill")
                        
                        StatView(
                            title: "BEST",
                            value: "\(highestScore)",
                            color: .yellow,
                            icon: "trophy.fill")
                        
                        StatView(
                            title: "TIME",
                            value: formattedTime,
                            color: .green,
                            icon: "timer")
                    }
                    .glassCard()
                    .padding(.horizontal)
                    
                    
                    
                    //Game Screen
                    Spacer()
                    
                    ZStack{
                        Button {
                            handleTap()
                            if !timerStarted {
                                startTimer()
                                startColorCycle()
                                startMoving()
                            }
                        }label:{
                            //TAP Button
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors:[
                                            buttonColor.opacity(0.15),
                                            buttonColor.opacity(0.8),
                                            buttonColor
                                        ],
                                        center:.center,
                                        startRadius: 20,
                                        endRadius: 140
                                    )
                                )
                                .frame(
                                    width:btnSize,
                                    height:btnSize
                                )
                                .overlay {
                                    Text("TAP")
                                        .font(.system(
                                            size:btnTextSize,
                                            weight: .black
                                        ))
                                        .foregroundColor(.white)
                                }
                                .shadow(
                                    color:buttonColor,
                                    radius:40
                                )
                                .shadow(color:buttonColor.opacity(0.8), radius: 70)
                        }
                        .offset(x: buttonOffsetX, y: buttonOffsetY)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onDisappear {
                        colorTimer?.invalidate()
                    }
                    
                    .frame(maxHeight:.infinity)
                    .frame(height: 400)
                    
                    Spacer()
                    
                    
                    HStack{
                        Label("COMBO x\(comboMultiplier)",
                              systemImage: "flame.fill"
                        )
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        
                        Spacer()
                        
                        Label(
                            buttonColor == .neonGreen ?
                            "BONUS MODE" :
                                buttonColor == .neonRed ?
                            "PENALTY MODE" :
                                "NORMAL MODE",
                            systemImage: "circle.fill"
                        ).foregroundColor(
                            buttonColor == .neonGreen ?
                                .neonGreen :
                                buttonColor == .neonRed ?
                                .neonRed :
                                    .neonBlue
                        )
                    }
                    .foregroundColor(.white)
                    .glassCard()
                    .padding(.horizontal)
                }
            }
        }
    }
    
}
#Preview {
    TapFrenzyView()
}
