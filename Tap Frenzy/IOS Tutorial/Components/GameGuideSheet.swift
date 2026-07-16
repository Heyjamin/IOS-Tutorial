//
//  GameGuideSheet.swift
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
                    title: Const.txtHowToWin,
                    icon: Const.trophyIcon,
                    color: .yellow,
                    items: Const.tapFrenzyHowToWin
                ),
                GameGuideSection(
                    title: Const.txtBonuses,
                    icon: Const.starFillIcon,
                    color: .neonGreen,
                    items: Const.tapFrenzyBonuses
                ),
                GameGuideSection(
                    title: Const.txtTraps,
                    icon: Const.trapsIcon,
                    color: .neonRed,
                    items: Const.tapFrenzyTraps
                ),
            ]
        case .lightItUp:
            return [
                GameGuideSection(
                    title: Const.txtHowToWin,
                    icon: Const.trapsIcon,
                    color: .yellow,
                    items: Const.lightItUpHowToWin
                ),
                GameGuideSection(
                    title: Const.txtBonuses,
                    icon: Const.starFillIcon,
                    color: .neonGreen,
                    items: Const.lightItUpBonuses
                ),
                GameGuideSection(
                    title: Const.txtTraps,
                    icon: Const.trapsIcon,
                    color: .neonRed,
                    items: Const.lightItUpTraps
                ),
            ]
        case .quizRush:
            return [
                GameGuideSection(
                    title: Const.txtHowToWin,
                    icon: Const.trophyIcon,
                    color: .yellow,
                    items: Const.quizRushHowToWin
                ),
                GameGuideSection(
                    title: Const.txtBonuses,
                    icon: Const.starFillIcon,
                    color: .neonGreen,
                    items: Const.quizRushBonuses
                ),
                GameGuideSection(
                    title: Const.txtHints,
                    icon: Const.hintIcon,
                    color: .yellow,
                    items: Const.quizRushHints
                ),
                GameGuideSection(
                    title: Const.txtTraps,
                    icon: Const.trapsIcon,
                    color: .neonRed,
                    items: Const.quizRushTraps
                ),
            ]
        }
    }
    
    static func title(for mode: GameMode) -> String{
        "\(mode.title) " + Const.txtGuide
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
                    Button(Const.txtDone){
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
    
    private var header: some View {
        HStack(spacing: 14){
            Image(systemName: mode.icon)
                .font(.title2)
                .foregroundStyle(GameGuideContent.accentColor(for: mode))
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(GameGuideContent.accentColor(for: mode).opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4){
                Text(mode.title)
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
                .foregroundColor(section.color)
            
            ForEach(section.items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10){
                    Circle()
                        .fill(section.color.opacity(0.8))
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

struct GameGuideButton: View {
    let mode: GameMode
    @State private var showGuide = false
    
    var body: some View {
        Button {
            AudioManager.shared.playSFX(.button)
            showGuide = true
        } label: {
            Image(systemName: Const.guideIcon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            Circle().stroke(GameGuideContent.accentColor(for: mode).opacity(0.06), lineWidth: 1)
                        )
                    )
                .shadow(color: GameGuideContent.accentColor(for: mode).opacity(0.35), radius: 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Const.txtGameGuide)
        .sheet(isPresented: $showGuide) {
            GameGuideSheet(mode: mode)
        }
    }
}


#Preview{
    GameGuideSheet(mode: .tapFrenzy)
}
