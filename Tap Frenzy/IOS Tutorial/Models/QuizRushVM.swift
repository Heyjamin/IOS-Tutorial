//
//  QuizRushVM.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import Foundation
import Combine

@MainActor
class QuizRushVM: ObservableObject {

    enum ViewState {
        case loading
        case loaded
        case failed(String)
    }

    @Published var state: ViewState = .loading
    @Published var questions: [TriviaQuestion] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var gameOver = false
    @Published var selectedAnswer: String?
    @Published var answerIsCorrect: Bool?
    @Published var correctAnswer: String?
    @Published var isAnswerLocked = false
    @Published var timeRemaining: Double = 0
    @Published var lastTimeBonus = 0
    @Published var lastBasePoints = 0
    @Published var feedbackText: String?
    @Published var timedOut = false
    @Published private(set) var hintsRemaining = 0
    @Published private(set) var questionHintKinds: [Int: QuizHintKind] = [:]

    private let api = TriviaAPI()
    private var stageLevel = 1
    private var levelSettings = QuizRushLevelSettings.settings(for: 1)
    private var timerTask: Task<Void, Never>?

    private static let maxHintsPerQuiz = 3

    enum HintMode {
        case playerChoice
        case randomAuto
        case none
    }

    var hintMode: HintMode {
        switch stageLevel {
        case 1...3: return .playerChoice
        case 4...7: return .randomAuto
        default: return .none
        }
    }

    var timeLimit: Double { levelSettings.questionTimeLimit }

    var timeProgress: Double {
        guard timeLimit > 0 else { return 0 }
        return max(0, min(timeRemaining / timeLimit, 1))
    }

    func configure(stageLevel: Int) {
        self.stageLevel = stageLevel
        self.levelSettings = QuizRushLevelSettings.settings(for: stageLevel)
    }

    func loadQuestions() async {
        stopQuestionTimer()
        state = .loading

        do {
            questions = try await api.fetchQuestions(amount: levelSettings.questionCount)
            currentIndex = 0
            score = 0
            streak = 0
            gameOver = false
            selectedAnswer = nil
            answerIsCorrect = nil
            isAnswerLocked = false
            timedOut = false
            feedbackText = nil
            setupHints()
            state = .loaded
            startQuestionTimer()
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    var currentQuestion: TriviaQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var canUseHint: Bool {
        hintMode == .playerChoice
            && hintsRemaining > 0
            && !isAnswerLocked
            && questionHintKinds[currentIndex] == nil
            && currentQuestion != nil
    }

    var currentHint: String? {
        guard let kind = questionHintKinds[currentIndex],
              let question = currentQuestion else { return nil }
        return question.hintText(kind: kind)
    }

    var visibleAnswers: [String] {
        guard let question = currentQuestion else { return [] }
        if questionHintKinds[currentIndex] == .fiftyFifty, !isAnswerLocked {
            return question.fiftyFiftyAnswers(from: question.displayAnswers)
        }
        return question.displayAnswers
    }

    func useHintOnCurrentQuestion() {
        guard canUseHint else { return }

        let hintsUsed = Self.maxHintsPerQuiz - hintsRemaining
        let kind = QuizHintKind.allCases[hintsUsed]
        questionHintKinds[currentIndex] = kind
        hintsRemaining -= 1
        AudioManager.shared.playSFX(.button)
    }

    private func setupHints() {
        questionHintKinds = [:]

        switch hintMode {
        case .playerChoice:
            hintsRemaining = Self.maxHintsPerQuiz
        case .randomAuto:
            hintsRemaining = 0
            guard !questions.isEmpty else { return }

            let indices = Array(questions.indices).shuffled().prefix(min(Self.maxHintsPerQuiz, questions.count))
            let kinds = QuizHintKind.allCases.shuffled()

            for (offset, questionIndex) in indices.enumerated() {
                questionHintKinds[questionIndex] = kinds[offset % kinds.count]
            }
        case .none:
            hintsRemaining = 0
        }
    }

    func selectAnswer(_ answer: String) {
        guard !isAnswerLocked, let question = currentQuestion else { return }
        stopQuestionTimer()
        processAnswer(answer: answer, question: question, fromTimeout: false)
    }

    func cleanup() {
        stopQuestionTimer()
    }

    func resetGame() {
        stopQuestionTimer()
        gameOver = false
        selectedAnswer = nil
        answerIsCorrect = nil
        isAnswerLocked = false
        timedOut = false
        feedbackText = nil

        Task {
            await loadQuestions()
        }
    }

    var resultMessage: String {
        let config = GameLevelConfig.config(mode: .quizRush, level: stageLevel)
        let stars = config.stars(for: score)
        switch stars {
        case 5: return Const.msgPerfect
        case 4: return Const.msgExcellent
        case 3: return Const.msgWellDone
        case 2: return Const.msgLevelCleared
        default: return Const.msgKeepPracticing
        }
    }

    // MARK: - Timer

    private func startQuestionTimer() {
        stopQuestionTimer()
        timeRemaining = levelSettings.questionTimeLimit

        timerTask = Task {
            while timeRemaining > 0, !isAnswerLocked {
                try? await Task.sleep(for: .milliseconds(100))
                if Task.isCancelled { return }
                timeRemaining -= 0.1
            }

            if !isAnswerLocked, timeRemaining <= 0 {
                timeRemaining = 0
                handleTimeout()
            }
        }
    }

    private func stopQuestionTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    private func handleTimeout() {
        guard !isAnswerLocked, let question = currentQuestion else { return }
        timedOut = true
        processAnswer(answer: "", question: question, fromTimeout: true)
        AudioManager.shared.playSFX(.penalty)
    }

    private func timeBonus(for remaining: Double) -> Int {
        guard timeLimit > 0 else { return 0 }
        let ratio = remaining / timeLimit
        return Int(ratio * Double(levelSettings.maxTimeBonus))
    }

    private func processAnswer(answer: String, question: TriviaQuestion, fromTimeout: Bool) {
        isAnswerLocked = true
        selectedAnswer = fromTimeout ? nil : answer
        correctAnswer = question.correct_answer
        answerIsCorrect = !fromTimeout && (answer.htmlDecoded == question.correct_answer.htmlDecoded)
        lastTimeBonus = 0
        lastBasePoints = 0

        if answerIsCorrect == true {
            streak += 1
            lastBasePoints = 10 + (streak * 2)
            lastTimeBonus = timeBonus(for: timeRemaining)
            score += lastBasePoints + lastTimeBonus
            feedbackText = Const.flash + " +\(lastBasePoints)" + Const.txtBase + " · +\(lastTimeBonus) " + Const.txtSpeedBonus
            AudioManager.shared.playSFX(.correct)
        } else {
            streak = 0
            score = max(score - 5, 0)
            feedbackText = fromTimeout
            ? Const.txtTimesUp
            : Const.txtWrong
            AudioManager.shared.playSFX(.wrong)
        }

        Task {
            let delay: Duration = answerIsCorrect == true
                ? .seconds(levelSettings.answerDelayCorrect)
                : .seconds(levelSettings.answerDelayWrong)
            try? await Task.sleep(for: delay)

            selectedAnswer = nil
            answerIsCorrect = nil
            isAnswerLocked = false
            correctAnswer = nil
            feedbackText = nil
            timedOut = false
            lastTimeBonus = 0
            lastBasePoints = 0
            nextQuestion()
        }
    }

    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            startQuestionTimer()
        } else {
            stopQuestionTimer()
            SessionStore.shared.recordSession(mode: .quizRush, score: score)
            AudioManager.shared.playSFX(.gameOver)
            gameOver = true
        }
    }
}
