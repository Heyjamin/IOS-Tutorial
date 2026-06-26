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
    
    @State private var highestScore = UserDefaults.standard.integer(forKey: "LightItUpHighestScore")
    
    @State private var timeRemaining = 60
    
    @State private var gameTimer: Timer?
    
    @State private var cellTimer: Timer?
    
    @State private var gameOver = false
    
    @State private var activeCell: Int? = nil
    
    @State private var wrongCell : Int? = nil
    
    @State private var activeColor: Color = .neonBlue
    
    @State private var showLevelBanner = false
    
    
    @State private var hideWorkItem: DispatchWorkItem?
    
    @State private var level = 1
    @State private var lightSpeed = 1.0
    
    private var columns : [GridItem] {
        switch level{
        case 1:
            return Array (repeating: GridItem(.flexible()), count: 3)
        case 2:
            return Array (repeating: GridItem(.flexible()), count: 2)
        case 3:
            return Array (repeating: GridItem(.flexible()), count: 3)
        default:
            return Array (repeating: GridItem(.flexible()), count: 3)
        }
    }
    
    private var visibleCards: Int{
        switch level {
        case 1:
            return 3
        case 2:
            return 4
        case 3:
            return 6
        default:
            return 9
        }
    }
    
    private func endGame() {
        LeaderboardManager.shared.addScore(playerName: playerName, score: score, gameName: "Light It Up")
        
        gameOver = true
    }
    
    private func resetGame() {
        
        gameTimer?.invalidate()
        cellTimer?.invalidate()
        
        gameOver = false
        
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
            
            switch timeRemaining{
            case 45:
                level = 2
                lightSpeed = 0.8
                
            case 30:
                level = 3
                lightSpeed = 0.6
                
            case 15:
                level = 4
                lightSpeed = 0.4
                
            default:
                break
            }
        
            if timeRemaining == 45 || timeRemaining == 30 || timeRemaining == 15 {
                withAnimation {
                    showLevelBanner = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                    withAnimation {
                        showLevelBanner = false
                    }
                }
                
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
        
        hideWorkItem?.cancel()
        
        activeCell = Int.random(in: 0..<visibleCards)
        
        activeColor = neonColors.randomElement() ?? .neonBlue
        
        let workItem = DispatchWorkItem {
            activeCell = nil
        }
        
        hideWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + max(lightSpeed * 0.8,0.5),
            execute:workItem
        )
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
    
    private let neonColors: [Color] = [
        .neonBlue,
        .neonGreen,
        .neonPink,
        .neonPurple,
        .yellow,
        .orange
    ]
    
  
    
    var body: some View {
        if gameOver {
            ZStack {
                LinearGradient(
                    colors:[.bgTop, .black, .bgBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack{
                    
                    Spacer()
                    
                    VStack(spacing:20){
                        
                        
                        Image(systemName:"trophy.fill")
                            .font(.system(size:80))
                            .foregroundColor(.yellow)
                        
                        Text("GAME OVER")
                            .font(.system(size:34,weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                
                            )
                        Divider()
                        
                        VStack(spacing:12){
                            
                            Label(playerName, systemImage: "person.fill")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            HStack{
                                VStack{
                                    Text("SCORE")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(score)")
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundColor(.neonGreen)
                                }
                                Spacer()
                                
                                VStack{
                                    
                                    Text("BEST")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(highestScore)")
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundColor(.yellow)
                                }
                            }
                            Divider()
                            
                            HStack {
                                Label(
                                "LEVEL \(level)",
                                 systemImage: "star.fill"
                                )
                                .foregroundColor(.neonPink)
                                
                                Spacer()
                                
                                Label(
                                    "\(60 - timeRemaining)s",
                                    systemImage: "clock.fill"
                                )
                                .foregroundColor(.cyan)
                            }
                            
                            
                        }
                        
                        Button {
                            resetGame()
                        }label:{
                            
                            Label(
                            "PLAY AGAIN",
                            systemImage:"arrow.clockwise"
                        )
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                        .background(
                            LinearGradient(
                                colors: [.neonBlue, .neonPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                    }
                }
                .padding(30)
                .glassCard()
                
                Spacer()
            }
            
        }
    
        } else {
            
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
                    
                    
                       StatCard(
                           title: "LEVEL",
                            value: "\(level)",
                           color: .neonPink,
                            icon: "star.fill").font(.largeTitle)
                    
                    if showLevelBanner {
                        Text("LEVEL \(level)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.yellow)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    ZStack{
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(0..<visibleCards, id: \.self) {index in
                                
                                RoundedRectangle(cornerRadius:16)
                                    .fill(
                                        wrongCell == index ?
                                        Color.red
                                        :
                                        activeCell == index ?
                                        activeColor
                                        : Color.white.opacity(0.08)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius:16)
                                            .stroke(
                                                activeCell == index ?
                                                    .white : .clear, lineWidth: 3
                                            )
                                    )
                                    .overlay{
                                        if wrongCell == index{
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size:32))
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .overlay{
                                        if activeCell == index {
                                            Image(systemName: "hand.tap.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(.white)
                                                .symbolEffect(.pulse)
                                        }
                                    }
                                    .shadow(
                                        color: activeCell == index ?
                                        activeColor
                                        : .clear,
                                        radius: activeCell == index ? 25: 0
                                    )
                                    .scaleEffect(activeCell == index ? 1.12 : 1.0)
                                    .rotationEffect(.degrees(activeCell == index ? 3:0)
                                                    )
                                        .animation(
                                            .spring(response: 0.25, dampingFraction: 0.65),
                                            value: activeCell
                                        )
                                
                                    .frame(width:90, height: 90)
                                
                                    .onTapGesture {
                                        if activeCell == index {
                                            score += 1
                                            
                                            if score > highestScore {
                                                highestScore = score
                                                
                                                UserDefaults.standard.set(
                                                    highestScore,
                                                    forKey: "LightItUpHighestScore"
                                                )
                                            }
                                            activeCell = nil
                                            hideWorkItem?.cancel()
                                            showRandomCell()
                                        }
                                        else
                                        {
                                        // Wrong Tap
                                            wrongCell = index
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                                wrongCell = nil
                                            }
                                            
                                            score = max(score - 1, 0)
                                            
                                        }
                                    }
                            }
                        }
                        .frame(height: 320)
                        
                    }
                }
                .padding()
                
            }
            
            .onAppear {
                
                showRandomCell()
                startCellTimer()
                startGameTimer()
                
            }
            
            .onDisappear {
                gameTimer?.invalidate()
                cellTimer?.invalidate()
                
            }
            
            
           
        }
        
    }
}

#Preview {
    LightItUpView()
}
