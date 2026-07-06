//
//  NeonAnimatedBackground.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-06.
//

import SwiftUI

enum NeonBackgroundStyle{
    case menu
    case game
    case calm
}

struct NeonAnimatedBackground: View {
    var style: NeonBackgroundStyle = .menu
    
    private var aurora: AuroraStyle{
        switch style{
        case .menu: return .menu
        case .game: return .game
        case .calm: return .calm
        }
    }
    
    var body: some View {
        ZStack{
            LiveAuroraBackground(
                base: aurora.base,
                auroraColors: aurora.colors,
                particleColor: aurora,colors[1].opacity(0.85),
                particleCount: style == .game ? 64 : 52
            )
            
            if style == .menu {
                MeteorShowerBackground(colors: meteorColors)
                    .opacity(0.75)
            }
        }
    }
    
    private var meteorColors: [Color]{
        [
            Color(red: 0.2, green: 0.85, blue: 0.95),
            Color(red: 0.75, green: 0.35, blue: 0.95),
            Color(red: 0.95, green: 0.45, blue: 0.75),
            Color(red: 0.95, green: 0.72, blue: 0.25),
            Color(red: 0.35, green: 0.75, blue: 1.0),
        ]
    }
}

extension View{
    func neonBackground(_ style: NeonBackgroundStyle = .menu) -> some View{
        background{
            NeonAnimatedBackground(style: style)
    }
    }
}

#Preview {
    NeonAnimatedBackground(style: .menu)
}
