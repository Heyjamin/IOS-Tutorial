//
//  GameTabBar.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI

struct GameTabBar: View {
    @ObservedObject private var navigation = AppNavigationStore.shared
    
    var body: some View {
        HStack (spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button{
                    AudioManager.shared.playSFX(.button)
                    navigation.selectTab(tab)
                } label: {
                    VStack(spacing: 3){
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: navigation.selectedTab == tab ? .bold : .regular))
                        Text(tab.title)
                            .font(.system(size:10, weight: .medium))
                    }
                    .foregroundColor(navigation.selectedTab == tab ? .neonBlue : .white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 6)
        .padding(.bottom, 2)
        .background(.ultraThinMaterial.opacity(0.95))
        .overlay(alignment: .top){
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 0.5)
        }
    }
}

#Preview{
    VStack{
        Spacer()
        GameTabBar()
    }
    .background(Color.black)
}
