//
//  LightItUpView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-19.
//

import SwiftUI

struct LightItUpView: View {
    let stageLevel: Int

    @State private var activeStageLevel: Int
    @State private var score = 0
    @State private var highestScore = UserDefaults.standard.integer(forKey: "LightItUpHighestScore")
    @State private var timeRemaining = 60
    @State private var gameTimer: Timer?
    @State private var cellTimer: Timer?
    @State private var gameOver = false
    @State private var activeCell: Int?
    @State private var wrongCell: Int?
    @State private var activeCellKind: LightCellKind = .normal
    @State private var hideWorkItem: DispatchWorkItem?
    @State private var starsEarned = 0
    @State private var toastMessage = ""

    @AppStorage("currentPlayer")
    private var playerName = ""

    init(stageLevel: Int = 1) {
        self.stageLevel = stageLevel
        _activeStageLevel = State(initialValue: stageLevel)
    }

    private var levelConfig: GameLevelConfig {
        GameLevelConfig.config(mode: .lightItUp, level: activeStageLevel)
    }

    private var settings: LightItUpLevelSettings {
        LightItUpLevelSettings.settings(for: activeStageLevel)
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: settings.columns)
    }

    private func endGame() {
        SessionStore.shared.recordSession(mode: .lightItUp, score: score)
        let result = LevelProgressStore.shared.recordResult(mode: .lightItUp, level: activeStageLevel, score: score)
        starsEarned = result.stars
        AudioManager.shared.playSFX(.gameOver)
        if score >= highestScore && score > 0 {
            highestScore = score
            UserDefaults.standard.set(highestScore, forKey: "LightItUpHighestScore")
            AudioManager.shared.playSFX(.success)
        }
        gameOver = true
    }

    private func resetGame() {
        gameTimer?.invalidate()
        cellTimer?.invalidate()
        gameOver = false
        score = 0
        timeRemaining = settings.duration
        starsEarned = 0
        toastMessage = ""
        startGameTimer()
        startCellTimer()
        showRandomCell()
    }

    private func startGameTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                timer.invalidate()
                cellTimer?.invalidate()
                endGame()
            }
        }
    }

    private func pickCellKind() -> LightCellKind {
        let roll = Double.random(in: 0...1)
        if roll < settings.trapChance { return .trap }
        if roll < settings.trapChance + settings.bonusChance { return .bonus }
        return .normal
    }

    private func showRandomCell() {
        hideWorkItem?.cancel()
        activeCell = Int.random(in: 0..<settings.visibleCards)
        activeCellKind = pickCellKind()

        let workItem = DispatchWorkItem { activeCell = nil }
        hideWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + settings.cellDisplayDuration,
            execute: workItem
        )
    }

    private func startCellTimer() {
        cellTimer?.invalidate()
        cellTimer = Timer.scheduledTimer(withTimeInterval: settings.lightSpeed, repeats: true) { _ in
            showRandomCell()
        }
    }

    private func cellColor(for index: Int) -> Color {
        if wrongCell == index { return .red.opacity(0.6) }
        guard activeCell == index else { return Color.white.opacity(0.08) }
        switch activeCellKind {
        case .normal: return .neonBlue
        case .bonus: return .neonGreen
        case .trap: return .neonRed
        }
    }

    private var nextLevelAction: (() -> Void)? {
        guard starsEarned >= GameLevelConfig.unlockStarsRequired,
              activeStageLevel < GameLevelConfig.levelsPerGame(for: .lightItUp),
              LevelProgressStore.shared.isUnlocked(mode: .lightItUp, level: activeStageLevel + 1)
        else { return nil }

        return {
            activeStageLevel += 1
            resetGame()
        }
    }

    var body: some View {
        if gameOver {
            LevelResultView(
                mode: .lightItUp,
                stageLevel: activeStageLevel,
                score: score,
                starsEarned: starsEarned,
                headline: "LEVEL COMPLETE",
                subtitle: toastMessage.isEmpty ? levelConfig.subtitle : toastMessage,
                bestScore: highestScore,
                isNewRecord: score >= highestScore && score > 0,
                onPlayAgain: resetGame,
                onNextLevel: nextLevelAction
            )
        } else {
            ZStack {
                LevelWorldBackground(world: levelConfig.world)

                VStack(spacing: 0) {
                    GameHUDBar(guideMode: .lightItUp)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        .padding(.bottom, 6)

                    VStack(spacing: 8) {
                        Text("💡 LIGHT IT UP · L\(activeStageLevel)")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [.neonBlue, .neonPurple], startPoint: .leading, endPoint: .trailing)
                            )

                        Text(levelConfig.world.title)
                            .font(.caption2)
                            .foregroundColor(.gray)

                        compactStatsRow
                        StarRatingView(stars: levelConfig.stars(for: score), size: 14)

                        if !toastMessage.isEmpty {
                            Text(toastMessage)
                                .font(.caption2.bold())
                                .foregroundColor(.yellow)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)

                    GeometryReader { geo in
                        let spacing: CGFloat = 10
                        let columnCount = settings.columns
                        let rowCount = max(1, Int(ceil(Double(settings.visibleCards) / Double(columnCount))))
                        let cellSize = min(
                            (geo.size.width - spacing * CGFloat(columnCount - 1)) / CGFloat(columnCount),
                            (geo.size.height - spacing * CGFloat(rowCount - 1)) / CGFloat(rowCount),
                            88
                        )

                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(0..<settings.visibleCards, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(cellColor(for: index))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(activeCell == index ? .white : .clear, lineWidth: 2)
                                    )
                                    .overlay {
                                        if wrongCell == index {
                                            Text("❌")
                                                .font(.system(size: cellSize * 0.32))
                                        } else if activeCell == index {
                                            Text(activeCellKind.emoji)
                                                .font(.system(size: cellSize * 0.38))
                                        }
                                    }
                                    .shadow(color: activeCell == index ? cellColor(for: index) : .clear, radius: 16)
                                    .scaleEffect(activeCell == index ? 1.08 : 1.0)
                                    .animation(.spring(response: 0.25, dampingFraction: 0.65), value: activeCell)
                                    .frame(width: cellSize, height: cellSize)
                                    .onTapGesture { handleCellTap(index) }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.horizontal, 16)

                    bottomLegendBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                }
            }
            .onAppear {
                timeRemaining = settings.duration
                showRandomCell()
                startCellTimer()
                startGameTimer()
                AudioManager.shared.playMusic(.lightItUp)
            }
            .onDisappear {
                gameTimer?.invalidate()
                cellTimer?.invalidate()
                AudioManager.shared.playMusic(.menu)
            }
        }
    }

    private var compactStatsRow: some View {
        HStack(spacing: 0) {
            lightStatItem(icon: "bolt.fill", label: "Score", value: "\(score)", color: .cyan)
            lightDivider
            lightStatItem(icon: "star.fill", label: "Target", value: "\(levelConfig.starThresholds[1])+", color: .yellow)
            lightDivider
            lightStatItem(icon: "timer", label: "Time", value: "\(timeRemaining)", color: .neonGreen)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }

    private var lightDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1, height: 28)
    }

    private func lightStatItem(icon: String, label: String, value: String, color: Color) -> some View {
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

    private var bottomLegendBar: some View {
        HStack(spacing: 12) {
            Label("⭐ Bonus", systemImage: "plus.circle")
                .font(.caption.bold())
                .foregroundColor(.neonGreen)

            Spacer(minLength: 8)

            Label("💣 Trap", systemImage: "minus.circle")
                .font(.caption.bold())
                .foregroundColor(.neonRed)
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

    private func handleCellTap(_ index: Int) {
        guard activeCell == index else {
            AudioManager.shared.playSFX(.wrong)
            wrongCell = index
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { wrongCell = nil }
            score = max(score - 1, 0)
            return
        }

        switch activeCellKind {
        case .normal:
            score += 1
            toastMessage = "+1 👆"
            AudioManager.shared.playSFX(.tap)
        case .bonus:
            score += settings.bonusPoints
            toastMessage = "⭐ BONUS +\(settings.bonusPoints)!"
            AudioManager.shared.playSFX(.bonus)
        case .trap:
            score = max(score - settings.trapPenalty, 0)
            toastMessage = "💣 TRAP -\(settings.trapPenalty)!"
            AudioManager.shared.playSFX(.penalty)
        }

        activeCell = nil
        hideWorkItem?.cancel()
        showRandomCell()
    }
}

#Preview {
    LightItUpView(stageLevel: 1)
}

