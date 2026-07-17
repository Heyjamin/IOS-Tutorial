//
//  QuizResultView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import SwiftUI

struct QuizRushView: View {
    let stageLevel: Int

    @StateObject private var viewModel = QuizRushVM()
    @State private var activeStageLevel: Int
    @State private var starsEarned = 0
    @State private var showResult = false
    @State private var finalScore = 0

    init(stageLevel: Int = 1) {
        self.stageLevel = stageLevel
        _activeStageLevel = State(initialValue: stageLevel)
    }

    private var levelConfig: GameLevelConfig {
        GameLevelConfig.config(mode: .quizRush, level: activeStageLevel)
    }

    var body: some View {
        ZStack {
            LevelWorldBackground(world: levelConfig.world)

            if showResult {
                LevelResultView(
                    mode: .quizRush,
                    stageLevel: activeStageLevel,
                    score: finalScore,
                    starsEarned: starsEarned,
                    headline: Const.txtQuizCompleted,
                    subtitle: viewModel.resultMessage,
                    bestScore: LevelProgressStore.shared.bestScore(mode: .quizRush, level: activeStageLevel),
                    isNewRecord: false,
                    onPlayAgain: {
                        showResult = false
                        viewModel.gameOver = false
                        viewModel.resetGame()
                    },
                    onNextLevel: nextLevelAction
                )
            } else {
                VStack(spacing: 0) {
                    GameHUDBar(guideMode: .quizRush)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        .padding(.bottom, 6)

                    content
                }
            }
        }
        .task(id: activeStageLevel) {
            viewModel.configure(stageLevel: activeStageLevel)
            await viewModel.loadQuestions()
        }
        .onAppear {
            AudioManager.shared.playMusic(.quizRush)
        }
        .onDisappear {
            viewModel.cleanup()
            AudioManager.shared.playMusic(.menu)
        }
        .onChange(of: viewModel.gameOver) { _, isOver in
            guard isOver else { return }
            let result = LevelProgressStore.shared.recordResult(
                mode: .quizRush,
                level: activeStageLevel,
                score: viewModel.score
            )
            starsEarned = result.stars
            finalScore = viewModel.score
            showResult = true
        }
    }

    private var nextLevelAction: (() -> Void)? {
        guard starsEarned >= GameLevelConfig.unlockStarsRequired,
              activeStageLevel < GameLevelConfig.levelsPerGame(for: .quizRush),
              LevelProgressStore.shared.isUnlocked(mode: .quizRush, level: activeStageLevel + 1)
        else { return nil }

        return {
            showResult = false
            viewModel.gameOver = false
            activeStageLevel += 1
            starsEarned = 0
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

    var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
            Text(Const.txtLoadingQuestions)
                .foregroundStyle(.white)
            Spacer()
        }
    }

    func errorView(_ message: String) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: Const.wiFiExclamationIcon)
                    .font(.system(size: 48))
                    .foregroundStyle(.red)
                Text(Const.txtUnableToLoadQuiz)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(message)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                Button(Const.txtRetry) {
                    Task { await viewModel.loadQuestions() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    func questionCard(_ question: TriviaQuestion) -> some View {
        VStack(spacing: 10) {
            Text(question.question)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
    }

    func answerList(_ question: TriviaQuestion) -> some View {
        VStack(spacing: 10) {
            ForEach(viewModel.visibleAnswers, id: \.self) { answer in
                AnswerButton(
                    title: answer,
                    isSelected: viewModel.selectedAnswer == answer,
                    isCorrect: viewModel.answerIsCorrect,
                    correctAnswer: viewModel.correctAnswer,
                    compact: true
                ) {
                    viewModel.selectAnswer(answer)
                }
                .disabled(viewModel.isAnswerLocked)
            }
        }
    }

    var hintUseButton: some View {
        Button {
            viewModel.useHintOnCurrentQuestion()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: Const.hintIcon)
                    .foregroundColor(.yellow)
                Text(Const.txtUseHint)
                    .font(.caption.weight(.bold))
                Spacer()
                Text("\(viewModel.hintsRemaining) " + Const.txtLeft)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(viewModel.canUseHint ? Color.yellow.opacity(0.15) : Color.white.opacity(0.06))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(viewModel.canUseHint ? Color.yellow.opacity(0.35) : Color.white.opacity(0.1), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canUseHint)
    }

    func hintBanner(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: Const.hintIcon)
                .font(.caption)
                .foregroundColor(.yellow)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.yellow.opacity(0.12))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.yellow.opacity(0.25), lineWidth: 1)
        }
    }

    var quizView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                VStack(spacing: 2) {
                    Text(Const.brain + Const.txtQuizRush.uppercased())
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(
                            LinearGradient(colors: [.neonBlue, .neonPurple], startPoint: .leading, endPoint: .trailing)
                        )
                    Text(Const.txtLevel.capitalized + " \(activeStageLevel) · \(levelConfig.world.title)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }

                compactStatsRow

                StarRatingView(stars: levelConfig.stars(for: viewModel.score), size: 14)
                    .padding(.vertical, 2)

                ProgressView(
                    value: Double(viewModel.currentIndex + 1),
                    total: Double(max(viewModel.questions.count, 1))
                )
                .tint(.neonBlue)
                .scaleEffect(y: 1.5)
                .padding(.horizontal, 4)

                QuizTimerBar(
                    timeRemaining: viewModel.timeRemaining,
                    timeLimit: viewModel.timeLimit,
                    progress: viewModel.timeProgress,
                    compact: true
                )

                if let question = viewModel.currentQuestion {
                    if viewModel.hintMode == .playerChoice {
                        hintUseButton
                    }

                    questionCard(question)

                    if let hint = viewModel.currentHint {
                        hintBanner(hint)
                    }

                    if let feedback = viewModel.feedbackText {
                        Text(feedback)
                            .font(.caption.bold())
                            .foregroundColor(viewModel.answerIsCorrect == true ? .neonGreen : .neonRed)
                            .multilineTextAlignment(.center)
                    } else if viewModel.answerIsCorrect == false || viewModel.timedOut {
                        Text(Const.correct + "\(viewModel.correctAnswer?.htmlDecoded ?? "")")
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                            .multilineTextAlignment(.center)
                    }

                    answerList(question)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    var compactStatsRow: some View {
        HStack(spacing: 0) {
            quizStatItem(icon: Const.listNumberIcon, label: Const.txtQ, value: "\(viewModel.currentIndex + 1)/\(viewModel.questions.count)", color: .cyan)
            divider
            quizStatItem(icon: Const.starFillIcon, label: Const.txtScore, value: "\(viewModel.score)", color: .neonGreen)
            divider
            quizStatItem(icon: Const.flameFillIcon, label: Const.txtStreak, value: "\(viewModel.streak)", color: .orange)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }

    var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1, height: 28)
    }

    func quizStatItem(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            Text(value)
                .font(.caption.bold().monospacedDigit())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct QuizTimerBar: View {
    let timeRemaining: Double
    let timeLimit: Double
    let progress: Double
    var compact: Bool = false

    private var timerColor: Color {
        if progress > 0.5 { return .neonGreen }
        if progress > 0.25 { return .yellow }
        return .neonRed
    }

    var body: some View {
        VStack(spacing: compact ? 4 : 6) {
            HStack {
                Label(Const.txtTimer, systemImage: Const.timerIcon)
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: Const.timerFormat, max(timeRemaining, 0)))
                    .font(.caption.bold().monospacedDigit())
                    .foregroundColor(timerColor)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    Capsule()
                        .fill(timerColor)
                        .frame(width: max(geo.size.width * progress, 0))
                }
            }
            .frame(height: compact ? 6 : 10)
        }
        .padding(compact ? 10 : 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }
}

#Preview {
    QuizRushView(stageLevel: 1)
}


