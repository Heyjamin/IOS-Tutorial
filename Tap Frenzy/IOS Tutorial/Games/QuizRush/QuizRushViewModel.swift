//
//  QuizRushViewModel.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class QuizRushViewModel: ObservableObject {
    
    // View State
    
    enum ViewState{
        case loading
        case loaded
        case failed(String)
    }
    
    
    // published Properties
    
    @Published var state: ViewState = .loading
    @Published var questions: [TriviaQuestion] = []
    
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    
    @Published var gameOver = false
    
    @Published var selectedAnswer: String?
    @Published var answerIsCorrect: Bool?
    
    private let service = TriviaService()
    
   func loadQuestions() async {
       state = .loading
       
       do {
           questions = try await service.fetchQuestions()
           
           currentIndex = 0
           score = 0
           streak = 0
           gameOver = false
           selectedAnswer = nil
           answerIsCorrect = nil
           
           state = .loaded
       }catch{
           print(error)
           state = .failed(error.localizedDescription)
       }
    }
    
    var currentQuestion: TriviaQuestion? {
        guard currentIndex < questions.count else { return nil }
        
        return questions[currentIndex]
    }
    
    var progressText: String {
        guard !questions.isEmpty else { return "0 / 10" }
        return "\(currentIndex + 1) / \(questions.count)"
    }
    
    func selectAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        selectedAnswer = answer
        answerIsCorrect = (answer == question.correct_answer)
        
        if answerIsCorrect == true {
            streak += 1
            score += 10 + (streak * 2)
        }else{
            streak = 0
            score = max(score - 5, 0)
        }
        
        Task{
            try? await Task.sleep(for: .milliseconds(800))
            
            selectedAnswer = nil
            answerIsCorrect = nil
            
            nextQuestion()
        }
    }
    
    func resetGame() {
        gameOver = false
        selectedAnswer = nil
        answerIsCorrect = nil
        
        Task{
            await loadQuestions()
        }
    }
    
    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }else{
            LeaderboardManager.shared.addScore(playerName:PlayerManager.shared.currentPlayer, score: score, gameName: "Quiz Rush")
            gameOver = true
        }
    }
}
