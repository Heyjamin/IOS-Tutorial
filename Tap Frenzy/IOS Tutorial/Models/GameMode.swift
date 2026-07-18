//
//  GameMode.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-07.
//

import Foundation

enum GameMode: String, Codable, CaseIterable, Identifiable, Hashable{
    case tapFrenzy
    case lightItUp
    case quizRush
    
    var id: String { title }
    
    var title: String{
        switch self{
        case .tapFrenzy: return Const.txtTapFrenzy.capitalized
        case .lightItUp: return Const.txtLightItUp.capitalized
        case .quizRush: return Const.txtQuizRush.capitalized
        }
    }
    
    var icon: String {
        switch self {
        case .tapFrenzy: return Const.tapFrenzyIcon
        case .lightItUp: return Const.lightItUpIcon
        case .quizRush: return Const.quizRushIcon
        }
    }
    
    var subtitle: String{
        switch self{
        case .tapFrenzy: return Const.txtTapFrenzySubTitile
        case .lightItUp: return Const.txtLightItUpSubTitle
        case .quizRush: return Const.txtQuizRushSubTitle
        }
    }
    
    var colorName: String{
        switch self{
        case .tapFrenzy: return Const.txtYellow
        case .lightItUp: return Const.txtBlue
        case .quizRush: return Const.txtPurple
        }
    }
    
    var destination: GameDestination {
        switch self {
        case .tapFrenzy: return .levelSelect(.tapFrenzy)
        case .lightItUp: return .levelSelect(.lightItUp)
        case .quizRush: return .levelSelect(.quizRush)
        }
    }
}
