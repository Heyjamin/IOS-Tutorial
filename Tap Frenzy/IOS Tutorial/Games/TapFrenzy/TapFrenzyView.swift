//
//  ContentView.swift
//  IOS Tutorial
//
//  Created by Nuwan Jeewantha COBSCCOMP251P-045.
//

import SwiftUI

struct TapFrenzyView: View {
    let stageLevel: Int

    @State private var activeStageLevel: Int
    @State private var comboMultiplier = 1
    @State private var lastTapTime = Date()
    @State private var isComboActive = false

    @State private var emojiMode: TapEmojiMode = .normal
    @State private var emojiTimer: Timer?
    @State private var currentEmoji: String = "👆"

    @State private var buttonOffsetX: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 0
    @State private var moveTimer: Timer?

    @State private var btnTextSize = CGFloat(72)
    @State private var playAreaSize = CGSize(width: 300, height: 260)

    @State private var score = 0
    @State private var highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
    @State private var isNewRecord = false
    @State private var timeRemaining = 10_000
    @State private var gameOver = false
    @State private var timerStarted = false
    @State private var toastMessage = ""
    @State private var starsEarned = 0

    @AppStorage("currentPlayer")
    var playerName = ""

    init(stageLevel: Int = 1) {
        self.stageLevel = stageLevel
        _activeStageLevel = State(initialValue: stageLevel)
    }

    private var levelConfig: GameLevelConfig {
        GameLevelConfig.config(mode: .tapFrenzy, level: activeStageLevel)
    }

    private var levelSettings: TapFrenzyLevelSettings {
        TapFrenzyLevelSettings.settings(for: activeStageLevel)
    }

    private var emojiGlowColor: Color {
        switch emojiMode {
        case .normal: return .neonBlue
        case .bonus: return .neonGreen
        case .penalty: return .neonRed
        }
    }

    var formattedTime: String {
        let seconds = (timeRemaining % 60000) / 1000
        let milliseconds = (timeRemaining % 1000) / 10
        return String(format: "%02d.%02d", seconds, milliseconds)
    }

    var body: some View {
        ZStack {
            LevelWorldBackground(world: levelConfig.world)

            if gameOver {
                LevelResultView(
                    mode: .tapFrenzy,
                    stageLevel: activeStageLevel,
                    score: score,
                    starsEarned: starsEarned,
                    headline: isNewRecord ? "NEW RECORD!" : "LEVEL COMPLETE",
                    subtitle: toastMessage.isEmpty ? levelConfig.subtitle : toastMessage,
                    bestScore: highestScore,
                    isNewRecord: isNewRecord,
                    onPlayAgain: resetGame,
                    onNextLevel: nextLevelAction
                )
            } else {
                VStack(spacing: 0) {
                    GameHUDBar(guideMode: .tapFrenzy)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        .padding(.bottom, 6)

                    VStack(spacing: 8) {
                        Text("⚡ TAP FRENZY · L\(activeStageLevel)")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [.cyan, .purple, .pink], startPoint: .leading, endPoint: .trailing)
                            )

                        compactStatsRow
                        StarRatingView(stars: levelConfig.stars(for: score), size: 14)

                        if !toastMessage.isEmpty {
                            Text(toastMessage)
                                .font(.caption2.bold())
                                .foregroundColor(emojiGlowColor)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)

                    GeometryReader { geo in
                        ZStack {
                            Color.clear
                                .onAppear { playAreaSize = geo.size }
                                .onChange(of: geo.size) { _, newSize in
                                    playAreaSize = newSize
                                }

                            Button {
                                handleTap()
                                if !timerStarted {
                                    startTimer()
                                    startEmojiCycle()
                                    startMoving()
                                }
                            } label: {
                                Text(displayEmoji)
                                    .font(.system(size: btnTextSize))
                                    .shadow(color: emojiGlowColor.opacity(0.85), radius: 10)
                                    .shadow(color: emojiGlowColor.opacity(0.45), radius: 22)
                            }
                            .buttonStyle(.plain)
                            .frame(width: max(btnTextSize * 1.6, 88), height: max(btnTextSize * 1.6, 88))
                            .contentShape(Rectangle())
                            .offset(x: buttonOffsetX, y: buttonOffsetY)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                    .padding(.horizontal, 12)

                    bottomStatusBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            AudioManager.shared.playMusic(.tapFrenzy)
            applyLevelSettings()
        }
        .onDisappear {
            emojiTimer?.invalidate()
            moveTimer?.invalidate()
            AudioManager.shared.playMusic(.menu)
        }
    }

    private var compactStatsRow: some View {
        HStack(spacing: 0) {
            tapStatItem(icon: "bolt.fill", label: "Score", value: "\(score)", color: .cyan)
            tapDivider
            tapStatItem(icon: "star.fill", label: "Target", value: "\(levelConfig.starThresholds[1])+", color: .yellow)
            tapDivider
            tapStatItem(icon: "timer", label: "Time", value: formattedTime, color: .neonGreen)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }

    private var tapDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1, height: 28)
    }

    private func tapStatItem(icon: String, label: String, value: String, color: Color) -> some View {
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
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }

    private var bottomStatusBar: some View {
        HStack(spacing: 12) {
            Label("COMBO ×\(comboMultiplier)", systemImage: "flame.fill")
                .font(.caption.bold())
                .foregroundColor(.orange)

            Spacer(minLength: 8)

            Label(modeLabel, systemImage: emojiMode == .penalty ? "exclamationmark.triangle.fill" : "sparkles")
                .font(.caption.bold())
                .foregroundColor(emojiGlowColor)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
    }

    private var displayEmoji: String {
        switch emojiMode {
        case .normal: return levelSettings.normalEmoji
        case .bonus: return levelSettings.bonusEmoji
        case .penalty: return levelSettings.penaltyEmoji
        }
    }

    private var modeLabel: String {
        switch emojiMode {
        case .normal: return "NORMAL"
        case .bonus: return "BONUS \(levelSettings.bonusEmoji)"
        case .penalty: return "TRAP \(levelSettings.penaltyEmoji)"
        }
    }

    private var nextLevelAction: (() -> Void)? {
        guard starsEarned >= GameLevelConfig.unlockStarsRequired,
              activeStageLevel < GameLevelConfig.levelsPerGame(for: .tapFrenzy),
              LevelProgressStore.shared.isUnlocked(mode: .tapFrenzy, level: activeStageLevel + 1)
        else { return nil }

        return {
            activeStageLevel += 1
            resetGame()
        }
    }

    private func applyLevelSettings() {
        timeRemaining = levelSettings.durationMs
        btnTextSize = 72
        currentEmoji = levelSettings.normalEmoji
    }

    func startEmojiCycle() {
        emojiTimer?.invalidate()
        emojiTimer = Timer.scheduledTimer(withTimeInterval: levelSettings.emojiInterval, repeats: true) { _ in
            if Double.random(in: 0...1) < levelSettings.specialChance {
                emojiMode = Bool.random() ? .bonus : .penalty
            } else {
                emojiMode = .normal
            }
        }
    }

    func startMoving() {
        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(withTimeInterval: levelSettings.moveInterval, repeats: true) { _ in
            let maxX = max(playAreaSize.width * 0.32, 40)
            let maxY = max(playAreaSize.height * 0.32, 40)
            withAnimation(.easeInOut(duration: 0.2)) {
                buttonOffsetX = CGFloat.random(in: -maxX...maxX)
                buttonOffsetY = CGFloat.random(in: -maxY...maxY)
            }
        }
    }

    func startTimer() {
        guard !timerStarted else { return }
        timerStarted = true

        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 10
                btnTextSize = max(44, btnTextSize - 0.01)
            } else {
                timer.invalidate()
                emojiTimer?.invalidate()
                moveTimer?.invalidate()
                finishGame()
            }
        }
    }

    private func finishGame() {
        SessionStore.shared.recordSession(mode: .tapFrenzy, score: score)
        let result = LevelProgressStore.shared.recordResult(mode: .tapFrenzy, level: activeStageLevel, score: score)
        starsEarned = result.stars

        if score > highestScore {
            highestScore = score
            UserDefaults.standard.set(highestScore, forKey: "HighestScore")
            isNewRecord = true
            AudioManager.shared.playSFX(.success)
        } else {
            isNewRecord = false
        }
        AudioManager.shared.playSFX(.gameOver)
        gameOver = true
    }

    func resetGame() {
        score = 0
        gameOver = false
        timerStarted = false
        comboMultiplier = 1
        lastTapTime = Date()
        isNewRecord = false
        emojiMode = .normal
        isComboActive = false
        buttonOffsetX = 0
        buttonOffsetY = 0
        toastMessage = ""
        starsEarned = 0
        emojiTimer?.invalidate()
        moveTimer?.invalidate()
        applyLevelSettings()
    }

    func handleTap() {
        let now = Date()
        let timeDifference = now.timeIntervalSince(lastTapTime)

        if timeDifference <= 0.5 {
            comboMultiplier = min(comboMultiplier + 1, 10)
            isComboActive = true
        } else {
            comboMultiplier = 1
        }
        lastTapTime = now

        var points = comboMultiplier

        switch emojiMode {
        case .bonus:
            points += levelSettings.bonusPoints
            toastMessage = "BONUS \(levelSettings.bonusEmoji) +\(points)"
            AudioManager.shared.playSFX(.bonus)
        case .penalty:
            points = -comboMultiplier
            toastMessage = "TRAP \(levelSettings.penaltyEmoji) \(points)"
            AudioManager.shared.playSFX(.penalty)
        case .normal:
            toastMessage = ""
            AudioManager.shared.playSFX(.tap)
        }

        score += points
        if score < 0 { score = 0 }
    }
}

#Preview {
    TapFrenzyView(stageLevel: 1)
}
