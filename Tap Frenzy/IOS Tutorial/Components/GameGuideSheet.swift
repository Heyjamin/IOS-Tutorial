//
//  GameCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI

struct GameGuideSection: Identifiable{
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let items: [String]
}

enum GameGuideContent {
    static func sections(for mode: GameMode) -> [GameGuideSection] {
            switch mode {
            case .tapFrenzy:
                return [
                    GameGuideSection(
                        title: "How to Win",
                        icon: "trophy.fill",
                        color: .yellow,
                        items: [
                            "Tap the emoji target as fast as you can before the timer hits zero.",
                            "Each correct tap adds points based on your combo multiplier.",
                            "Tap quickly in a row (within 0.5s) to build combo up to ×10.",
                            "Earn ★★ (2 stars) or more to unlock the next level.",
                            "Higher score = more stars — check the target on screen.",
                        ]
                    ),
                    GameGuideSection(
                        title: "Bonuses",
                        icon: "star.fill",
                        color: .neonGreen,
                        items: [
                            "⭐ 🌟 💎 🏆 💫 — bonus emojis give extra points on top of combo.",
                            "Bonus emojis appear randomly — tap them quickly!",
                        ]
                    ),
                    GameGuideSection(
                        title: "Traps",
                        icon: "exclamationmark.triangle.fill",
                        color: .neonRed,
                        items: [
                            "💤 😴 💢 ☠️ 🧨 — trap emojis subtract your combo value from score.",
                            "The emoji moves around and shrinks as time runs out — stay focused!",
                            "Missing taps costs nothing, but traps will pull your score down.",
                        ]
                    ),
                ]
            case .lightItUp:
                return [
                    GameGuideSection(
                        title: "How to Win",
                        icon: "trophy.fill",
                        color: .yellow,
                        items: [
                            "Tap the lit cell when an emoji appears on the grid.",
                            "Normal cells 👆 give +1 point each.",
                            "Score as much as you can before the countdown ends.",
                            "Earn ★★ (2 stars) or more to unlock the next level.",
                        ]
                    ),
                    GameGuideSection(
                        title: "Bonuses",
                        icon: "star.fill",
                        color: .neonGreen,
                        items: [
                            "⭐ Bonus cells give extra points (varies by level).",
                            "They glow green — tap them before they disappear!",
                        ]
                    ),
                    GameGuideSection(
                        title: "Traps",
                        icon: "exclamationmark.triangle.fill",
                        color: .neonRed,
                        items: [
                            "💣 Trap cells subtract points — they glow red.",
                            "Tapping a dark / unlit cell costs −1 point.",
                            "Cells only stay visible for a short time — react fast!",
                            "Higher levels add more traps and a bigger grid.",
                        ]
                    ),
                ]
            case .quizRush:
                return [
                    GameGuideSection(
                        title: "How to Win",
                        icon: "trophy.fill",
                        color: .yellow,
                        items: [
                            "Pick the correct answer for each trivia question.",
                            "Correct answer: 10 base pts + streak bonus (streak × 2).",
                            "Answer faster to earn a speed bonus — watch the timer bar!",
                            "Complete all questions with the highest score you can.",
                            "Earn ★★ (2 stars) or more to unlock the next level.",
                        ]
                    ),
                    GameGuideSection(
                        title: "Speed Bonus",
                        icon: "bolt.fill",
                        color: .neonBlue,
                        items: [
                            "Each question has a countdown timer.",
                            "More time left = bigger speed bonus on correct answers.",
                            "Higher levels give less time but bigger max bonuses.",
                        ]
                    ),
                    GameGuideSection(
                        title: "Hints",
                        icon: "lightbulb.fill",
                        color: .yellow,
                        items: [
                            "Easy (L1–3): 3 hints — tap Use Hint on any question you choose.",
                            "1st hint = category · 2nd = first letter · 3rd = 50/50 answers.",
                            "Medium (L4–7): 3 random hints appear automatically on random questions.",
                            "Hard (L8–10): No hints — you're on your own!",
                        ]
                    ),
                    GameGuideSection(
                        title: "Traps",
                        icon: "exclamationmark.triangle.fill",
                        color: .neonRed,
                        items: [
                            "Wrong answer: −5 points and your streak resets to zero.",
                            "Timer runs out: counts as wrong (−5 pts), correct answer shown.",
                            "Don't rush blindly — a wrong tap hurts more than a slow correct one.",
                        ]
                    ),
                ]
            }
        }
    
    static func tite(for mode: GameMode) -> String{
        "\(mode.rawValue) Guide"
    }
    
    static func accentColor(for mode: GameMode) -> Color {
        switch mode{
        case .tapFrenzy: return .yellow
        case .lightItUp: return .neonBlue
        case .quizRush: return .neonPurple
        }
    }
}

struct GameGuideSheet: View {
    
    let mode: GameMode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(red:0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing: 16){
                        header
                        
                        ForEach(GameGuideContent.sections(for: mode)){ section in
                            guideSectionCard(section)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(GameGuideContent.title(for: mode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        AudioManager.shared.playSFX(.button)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium,.large])
        .presentationDragIndicator(.visible)
    }
    
    private var header: some View{
        HStack(spacing: 14){
            Image(systemName: mode.icon)
                .font(.title2)
                .foregroundStyle(GameGuideCOntent.accentColor(fro: mode))
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(GameGuideContent.accentColor(for: mode).opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4){
                Text(mode.rawValue)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                Text(mode.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .glassCard()
    }
    
    private func guideSectionCard(_ section: GameGuideSection) -> some View{
        VStack(alignment: .leading, spacing: 12){
            Label(section.title, systemImage: section.icon)
                .font(.subheadline.bold())
                .foregroundColor(section.colr)
            
            ForEach(section.items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10){
                    Circle()
                        .fill(section.colr.opacity(0.8))
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    
                    Text(item)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white.opacity(0.06))
                    )
        .overlay{
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(section.color.opacity(0.25), lineWidth: 1)
        }
    }
    
}

struct GameGuideButton: View{
    let mode: GameMode
    @State private var showGuide = false
    
    var body: some View {
        Button{
            AudioManager.shared.playSFX(.button)
            showGuide = true
        } label: {
            Image(systemName: "book.fill")
                .font(.system(size:16, weight: .bold))
                .foregroundColor(.white)
                .frame(width:40, height: 40)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            Circle().stroke(GameGuideContent.accentColor(for: mode).opacity(0.6), StrokeStyle(lineWidth: 1)
                                           )
                        )
                        .shadow(color: GameGuideContent.accentColor(for: mode).opacity(0.35), radius: 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Game guide")
        .sheet(isPresented: $showGuide){
            GameGuideSheet(mode: mode)
        }
    }
}

#Preview{
    GameGuideSheet(mode: .tapFrenzy)
}
