//
//  LevelWorldBackground.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-06.
//
import SwiftUI

struct LevelWorldBackground: View {
    let world: LevelWorld
    
    private var palette: WorldPalette {
        .forWorld(world)
    }
    
    var body: some View {
        LiveAuroraBackground(
            base: palette.base,
            auroraColors: palette.aurora,
            particleColor = palette.particle,
            particleCount: 56
            
        )
    }
}

#Preview {
    LevelWorldBackground(world: .volcano)
}

