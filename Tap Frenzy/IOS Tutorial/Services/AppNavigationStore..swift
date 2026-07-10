//
//  AppNavigationStore..swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-09.
//

import Foundation
import Combine

enum AppTab: Hashable, CaseIterable {

    case home
    case stats
    case map
    case settings
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .stats: return "Status"
        case .map: return "Map"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "gamecontroller"
        case .stats: return "chart.bar"
        case .map: return "map"
        case .settings: return "gear"
        }
    }
}

@MainActor
final class AppNavigationStore: ObservableObject {
    static let shared = AppNavigationStore()
    
    @Published var selectedTab: AppTab = .home
    @Published private(set) var homeResetToken = UUID()
    
    private init() { }
    
    func selectTab(_ tab: AppTab) {
        selectedTab = tab
        resetHomeNavigation()
    }
    
    func resetHomeNavigation() {
        homeResetToken = UUID()
    }
}
