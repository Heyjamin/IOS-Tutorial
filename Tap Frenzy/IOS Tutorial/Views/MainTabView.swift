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
                    Label(Const.Home, systemImage:Const.gameControllerIcon)
                }
                .tag(AppTab.home)
            StatsTab()
                .tabItem{
                    Label(Const.Status, systemImage: Const.chartBarIcon)
                }
                .tag(AppTab.stats)
            MapTab()
                .tabItem{
                    Label(Const.Map, systemImage: Const.mapIcon)
                }
                .tag(AppTab.map)
            SettingsTab()
                .tabItem{
                    Label(Const.Settings, systemImage: Const.gearIcon)
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

#Preview {
    MainTabView()
}
