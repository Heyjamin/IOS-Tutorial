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
        case .home: return Const.Home
        case .stats: return Const.Status
        case .map: return Const.Map
        case .settings: return Const.Settings
        }
    }

    var icon: String {
        switch self {
        case .home: return Const.gameControllerIcon
        case .stats: return Const.chartBarIcon
        case .map: return Const.mapIcon
        case .settings: return Const.gearIcon
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
