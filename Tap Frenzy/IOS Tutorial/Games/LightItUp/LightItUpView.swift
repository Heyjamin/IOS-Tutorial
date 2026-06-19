//
//  LightItUpView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-19.
//

import SwiftUI

struct LightItUpView: View {
    
    @AppStorage("currentPlayer")
    private var playerName = ""
    
    @State private var score = 0
    
    @State private var highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
    
    @State private var timeRemaining = 60
    
    @State private var gameTimer: Timer?
    
    @State private var cellTimer: Timer?
    
    @State private var gameOver = false
    
    @State private var activeCell: Int? = nil
    
    @State private var level = 1
    @State private var lightSpeed = 1.0
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private func endGame() {
        LeaderboardManager.shared.addScore(playerName: playerName, score: score, gameName: "Light It Up")
        
        gameOver = true
    }
    
    private func resetGame() {
        score = 0
        timeRemaining = 60
        
        level = 1
        lightSpeed = 1.0
        
        startGameTimer()
        startCellTimer()
        
        showRandomCell()
    }
    
    private func startGameTimer()
    {
        gameTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ){
            timer in
            
            timeRemaining -= 1
            
            if timeRemaining == 45 {
                level = 2
                lightSpeed = 0.8
                startCellTimer()
            }
            
            if timeRemaining == 30 {
                level = 3
                lightSpeed = 0.6
                startCellTimer()
            }
            
            if timeRemaining == 15 {
                level = 4
                lightSpeed = 0.4
                startCellTimer()
            }
            
            if timeRemaining <= 0{
                timer.invalidate()
                cellTimer?.invalidate()
                gameTimer?.invalidate()
                
                endGame()
            }
        }
    }
    
    private func showRandomCell() {
            activeCell = Int.random(in: 0..<9)
    }
    
    private func startCellTimer()
    {
        cellTimer?.invalidate()
        
        cellTimer = Timer.scheduledTimer(
            withTimeInterval: lightSpeed,
            repeats: true
        ){
            _ in
            showRandomCell()
        }
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [.bgTop, .black, .bgBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("💡 LIGHT IT UP")
                    .font(.system(size:32,weight: .black))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.neonBlue, .neonPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack {
                    StatCard(
                        title: "SCORE",
                        value: "\(score)",
                        color: .cyan,
                        icon: "bolt.fill")
                    
                    StatCard(
                        title: "HIGHEST SCORE",
                        value: "\(highestScore)",
                        color: .yellow,
                        icon: "trophy.fill")
                    
                    StatCard(
                        title: "TIME",
                        value: "\(timeRemaining)",
                        color: .green,
                        icon: "timer")
                }
                
                VStack(spacing: 10) {
                    StatCard(
                        title: "LEVEL",
                        value: "\(level)",
                        color: .neonPink,
                        icon: "star.fill")
                }
                
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(0..<9, id: \.self) {index in
                        
                        RoundedRectangle(cornerRadius:16)
                            .fill(
                                activeCell == index ?
                                Color.neonBlue
                                : Color.white.opacity(0.1)
                            )
                            .frame(height: 90)
                            .onTapGesture {
                                if activeCell == index {
                                    score += 1
                                    
                                    if score > highestScore {
                                        highestScore = score
                                        
                                        UserDefaults.standard.set(
                                            highestScore,
                                            forKey: "HighestScore"
                                        )
                                    }
                                    
                                    showRandomCell()
                                }
                            }
                    }
                }
                
                Spacer()
            }
            .padding()
        }.onAppear {
            showRandomCell()
            startCellTimer()
            startGameTimer()
        }
                .onDisappear {
                    gameTimer?.invalidate()
                    cellTimer?.invalidate()
            
        }.alert(
            "Game Over",
            isPresented: $showGameOver){
                Button("Play Again"){
                    resetGame()
                }
            } message:{
                Text ("Final Score: \(score)")
            }
    }
   
}

#Preview {
    LightItUpView()
}
