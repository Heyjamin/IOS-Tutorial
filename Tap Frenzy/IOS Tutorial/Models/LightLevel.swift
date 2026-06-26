//
//  LightLevel.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-26.
//

import Foundation

struct LightLevel  {
    let number: Int
    let lightSpeed: Double
    let startTime: Int
    let visibleCards: Int
}

private let levels = [
    LightLevel(number:1,lightSpeed: 1.0,startTime: 60, visibleCards: 3),
    LightLevel(number:2,lightSpeed: 0.8,startTime: 45, visibleCards: 4),
    LightLevel(number:3,lightSpeed: 0.6,startTime: 30, visibleCards: 6),
    LightLevel(number:4,lightSpeed: 0.4,startTime: 15, visibleCards: 9)
]
