//
//  MainTabView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject private var navigation = AppNavigationStore.shared
    
    var body: some View {
        TabView(selection: $navigation.selectedTab){
            HomeTab()
                .tabItem {
                    Label("Home", systemImage:"gamecontroller")
                }
                .tag(AppTab.home)
            StatsTab()
                .tabItem{
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(AppTab.stats)
            MapTab()
                .tabItem{
                    Label("Map", systemImage: "map")
                }
                .tag(AppTab.map)
            SettingsTab()
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
                .tag(AppTab.settings)
        }
        .tint(.neonBlue)
        .onAppear {
            AudioManager.shared.configureSession()
            AudioManager.shared.playMusic(.menu)
        }
    }
}
