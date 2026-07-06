//
//  Untitled.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-06.
//
import SwiftUI

enum AuroraStyle{
    case menu
    case game
    case calm
    
    var colors: [Color] {
        switch self {
        case .menu:
            return [
                Color(red: 0.08, green: 0.22, blue: 0.31),
                Color(red: 0.45, green: 0.18, blue: 0.32),
                Color(red: 0.72, green: 0.42, blue: 0.18),
                Color(red: 0.12, green: 0.38, blue: 0.28),
            ]
            case .game:
            return[
                Color(red: 0.55, green: 0.12, blue: 0.18),
                Color(red: 0.82, green: 0.35, blue: 0.08),
                Color(red: 0.28, green: 0.10, blue: 0.42),
                Color(red: 0.15, green: 0.28, blue: 0.55),
            ]
        case .calm:
            return [
                Color(red: 0.10, green: 0.16, blue: 0.32),
                Color(red: 0.22, green: 0.28, blue: 0.48),
                Color(red: 0.35, green: 0.22, blue: 0.42),
                Color(red: 0.08, green: 0.24, blue: 0.30),
            ]
        }
    }
    
    var base: Color{
        Color(red: 0.04, green: 0.05, blue: 0.09)
    }
    
}


struct WorldPalette {
    let base: Color
    let aurora: [Color]
    let particle: Color
    
    
    static func forWorld(_ world: LevelWord) -> WorldPalette {
        switch world {
        case .meadow:
            return WorldPalette(
                base: Color(red: 0.03, green: 0.08, blue: 0.06),
                aurora: [
                    Color(red: 0.12, green: 0.38, blue: 0.22),
                    Color(red: 0.55, green: 0.38, blue: 0.12),
                    Color(red: 0.08, green: 0.28, blue: 0.18),
                    Color(red: 0.72, green: 0.55, blue: 0.22),
                ],
                particle: Color(red: 0.85, green: 0.72, blue: 0.35)
            )
        case .ocean:
            return WorldPalette(
                base: Color(red: 0.02, green: 0.06, blue: 0.14),
                aurora: [
                    Color(red: 0.05, green: 0.28, blue: 0.42),
                    Color(red: 0.10, green: 0.55, blue: 0.58),
                    Color(red: 0.18, green: 0.32, blue: 0.62),
                    Color(red: 0.04, green: 0.18, blue: 0.35),
                ],
                particle: Color(red: 0.55, green: 0.88, blue: 0.92)
            )
        case .sunset:
            return WorldPalette(
                base: Color(red: 0.10, green: 0.04, blue: 0.10),
                aurora: [
                    Color(red: 0.55, green: 0.12, blue: 0.38),
                    Color(red: 0.82, green: 0.28, blue: 0.12),
                    Color(red: 0.62, green: 0.15, blue: 0.42),
                    Color(red: 0.38, green: 0.08, blue: 0.22),
                ],
                particle: Color(red: 0.98, green: 0.62, blue: 0.38)
            )
        case .volcano:
            return WorldPalette(
                base: Color(red: 0.09, green: 0.03, blue: 0.02),
                aurora: [
                    Color(red: 0.72, green: 0.18, blue: 0.05),
                    Color(red: 0.92, green: 0.42, blue: 0.08),
                    Color(red: 0.45, green: 0.08, blue: 0.05),
                    Color(red: 0.28, green: 0.05, blue: 0.08),
                ],
                particle: Color(red: 1.0, green: 0.55, blue: 0.18)
            )
        case .cosmos:
            return WorldPalette(
                base: Color(red: 0.03, green: 0.02, blue: 0.08),
                aurora: [
                    Color(red: 0.35, green: 0.12, blue: 0.62),
                    Color(red: 0.18, green: 0.08, blue: 0.42),
                    Color(red: 0.55, green: 0.22, blue: 0.72),
                    Color(red: 0.08, green: 0.12, blue: 0.38),
                ],
                particle: Color(red: 0.82, green: 0.78, blue: 1.0)
            )
        }
    }
    
}
