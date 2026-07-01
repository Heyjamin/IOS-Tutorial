//
//  QuizRushView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct QuizRushView: View {
    
    @StateObject var viewModel = QuizRushViewModel()
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [.bgTop, .black, .bgBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
            
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadQuestions()
        }
        .fullScreenCover(isPresented: $viewModel.gameOver) {
            QuizResultView(score: viewModel.score)
        }
        
    }
}
        
        
        private extension QuizRushView {
            
            @ViewBuilder
            var content: some View {
                
                switch viewModel.state {
                case .loading:
                    
                    loadingView
                    
                case .loaded:
                    quizView
                    
                case .failed(let message):
                    
                    errorView(message)
                    
                }
            }
            
        }
        
        private extension QuizRushView{
            
            var loadingView: some View {
                
                VStack (spacing: 20){
                    
                    ProgressView()
                    
                    Text("Loading Questions...")
                        .foregroundStyle(.white)
                    
                }
            }
        }
        
        private extension QuizRushView{
            
            func errorView(_ message: String) -> some View {
                
                VStack (spacing: 20){
                    
                    Image(systemName:"wifi.exclamationmark")
                        .font(.system(size:60))
                        .foregroundStyle(.red)
                    
                    Text("Unable to load questions")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(message)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task{
                            await viewModel.loadQuestions()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        
        private extension QuizRushView {
            
            var quizView: some View {
                VStack(spacing: 20) {
                    Text(viewModel.progressText)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("Score: \(viewModel.score)")
                        .foregroundStyle(.green)
                    
                    Text("🔥 Streak: \(viewModel.streak)")
                        .foregroundStyle(.orange)
                    
                    Spacer()
                    
                    if let question = viewModel.currentQuestion {
                        
                        VStack{
                            
                            Text(question.question)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                
                        }
                        .padding()
                        .glassCard()
                        
                        VStack(spacing:15){
                            ForEach(question.allAnswers, id: \.self) {
                                answer in
                                
                                AnswerButton(title:answer){
                                    viewModel.selectAnswer(answer)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    

