//
//  MeteorShowerBackground.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-06.
//

import SwiftUI

struct MeteorShowerBackground: View {
    let colors: [Color]
    var meteorCount: Int = 14
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0/45.0)){ timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for index in 0..<meteorCount {
                    drawMeteor(
                        context: &context,
                        size: size,
                        index: index,
                        time: time,
                    )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
    
    private func drawMeteor(
        context: inout GraphicsContext,
        size: CGSize,
        index: Int,
        time: Double
    ){
        let seed = Double(index) * 1.6180339887
        let speed = 140 + seed.truncatingRemainder(dividingBy: 90)
        let span = Double(size.height + size.width) * 1.15
        let cycle = span/speed + seed.truncatingRemainder(dividingBy: 4)
        let phase = (time * 0.85 + seed * 2.3).truncatingRemainder (dividingBy: cycle)
        let progress = phase / cycle
        
        let startX = (sin(seed * 2.7) * 0.05 + 0.5) * size.width * 1.25 - size.width * 0.12
        let startY = -60.0 - seed.truncatingRemainder(dividingBy: 80)
        let angle = Double.pi * 0.22 + sin(seed * 1.4) * 0.08
        let travel = span * progress
        
        let headX = startX + cos(angle) * travel
        let headY = startY + sin(angle) * travel
        
        guard headY < size.height + 80, headX > -80, headX < size.width + 80 else { return }
        
        let trailLength = 55 + seed.truncatingRemainder(dividingBy: 45)
        let tailX = headX - cos(angle) * trailLength
        let tailY = headY - sin(angle) * trailLength
        let color = colors[index % colors.count]
        
        var trail = Path()
        trail.move(to: CGPoint(x: tailX, y: tailY))
        trail.addLine(to: CGPoint(x: headX, y: headY))
        
        context.stroke(
        trail,
        with: .linearGradient(
            Gradient(colors: [color.opacity(0), color.opacity(0.85)]),
            startPoint: CGPoint(x: tailX, y: tailY),
            endPoint: CGPoint(x: headX, y: headY)
        ),
        style: StrokeStyle(lineWidth: 2.2, lineCap: .round)
        )
        
        var glow = Path()
        glow.addEllipse(in: CGRect(x: headX - 3, y: headY - 3, width: 6, height: 6))
        context.fill(glow, with: .color(.white.opacity(0.92)))
        
        var halo = Path()
        halo.addEllipse(in: CGRect(x: headX - 6, y: headY - 6, width: 12, height: 12))
        context.fill(halo, with: .color(color.opacity(0.45)))
    }
}

#Preview {
    ZStack {
        Color(red: 0.04, green: 0.05, blue: 0.09).ignoresSafeArea()
        MeteorShowerBackground(colors: AuroraStyle.menu.colors)
    }
}
