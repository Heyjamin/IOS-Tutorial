//
//  QuizRushView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct QuizRushView: View {
    
    @StateObject var viewModel = QuizRushViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button{
                    dismiss()
                }label:{
                    Label("Arcade", systemImage:"chevron.left")
                        .foregroundStyle(.white)
                }
            }
        }
        .task {
            await viewModel.loadQuestions()
        }
        .fullScreenCover(isPresented: $viewModel.gameOver) {
            QuizResultView(score: viewModel.score){
                viewModel.resetGame()
            }
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
                    
                    Text("🧠 QUIZ RUSH")
                        .font(.system(size:32,weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.neonBlue, .neonPurple],
                                startPoint: .leading,
                                endPoint: .trailing)
                        )
                    
                    VStack{
                        ProgressView(
                            value: Double(viewModel.currentIndex + 1),
                            total: Double(viewModel.questions.count)
                        )
                        .tint(.neonBlue)
                        .scaleEffect(y:2)
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    HStack{
                        StatCard(
                                title: "QUESTION",
                                value: "\(viewModel.currentIndex + 1) /\(viewModel.questions.count)",
                                color:.cyan,
                                icon: "list.number"
                           )
                        
                        StatCard(
                            title:"SCORE",
                            value:"\(viewModel.score)",
                            color: .green,
                            icon: "star.fill"
                        )
                        
                        StatCard(
                            title: "STREAK",
                            value:"\(viewModel.streak)",
                            color: .orange,
                            icon:"flame.fill"
                        )
                    }
                    
//                    Text(viewModel.progressText)
//                        .font(.headline)
//                        .foregroundStyle(.white)
//                    
//                    Text("Score: \(viewModel.score)")
//                        .foregroundStyle(.green)
//                    
//                    Text("🔥 Streak: \(viewModel.streak)")
//                        .foregroundStyle(.orange)
                    
                    Spacer()
                    
                    
                    if let question = viewModel.currentQuestion {
                        
                        VStack (spacing:15){
                            
                            Image(systemName:"brain.head.profile.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(Color.neonPurple)
                            
                            Text(question.question.htmlDecoded)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight:170)
                        .padding()
                        .glassCard()
                        
                        
                        
                        VStack(spacing:15){
                            ForEach(question.allAnswers, id: \.self) {
                                answer in
                                
                                AnswerButton(
                                    title:answer,
                                    isSelected: viewModel.selectedAnswer == answer,
                                    isCorrect: viewModel.answerIsCorrect
                                
                                ){
                                    guard viewModel.selectedAnswer == nil else { return }
                                    
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


#Preview {
    QuizRushView()
}
