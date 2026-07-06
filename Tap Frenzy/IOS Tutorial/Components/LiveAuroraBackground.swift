//
//  LiveAuroraBackground.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-06.
//

import SwiftUI

struct LiveAuroraBackground: View {
    let base: Color
    let auroraColors: [Color]
    let particleColor: Color
    let particleCount: Int

    init(
        base: Color,
        auroraColors: [Color],
        particleColor: Color = .white.opacity(0.6),
        particleCount: Int = 48
    ) {
        self.base = base
        self.auroraColors = auroraColors
        self.particleColor = particleColor
        self.particleCount = particleCount
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                base

                auroraMesh(time: t)
                    .opacity(0.72)
                    .blur(radius: 28)

                auroraMesh(time: t + 4.2, inverted: true)
                    .opacity(0.45)
                    .blur(radius: 42)

                particleField(time: t)
                    .opacity(0.55)

                LinearGradient(
                    colors: [.clear, base.opacity(0.35), base.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private func auroraMesh(time: Double, inverted: Bool = false) -> some View {
        let wobble = Float(sin(time * 0.35) * 0.12)
        let drift = Float(cos(time * 0.22) * 0.10)
        let meshColors = inverted
            ? [auroraColors[2], auroraColors[0], auroraColors[3],
               auroraColors[1], auroraColors[2], auroraColors[0],
               auroraColors[3], auroraColors[1], auroraColors[2]]
            : [auroraColors[0], auroraColors[1], auroraColors[2],
               auroraColors[1], auroraColors[3], auroraColors[0],
               auroraColors[2], auroraColors[3], auroraColors[1]]

        return MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0.5 + wobble, 0], [1, 0],
                [0, 0.5 + drift], [0.5, 0.5 - drift], [1, 0.5 - wobble],
                [0, 1], [0.5 - drift, 1], [1, 1],
            ],
            colors: meshColors
        )
    }

    private func particleField(time: Double) -> some View {
        Canvas { context, size in
            for i in 0..<particleCount {
                let seed = Double(i) * 1.618
                let x = (sin(seed * 2.1 + time * (0.08 + seed.truncatingRemainder(dividingBy: 0.05))) * 0.5 + 0.5) * size.width
                let y = ((seed * 97.3 + time * (12 + seed.truncatingRemainder(dividingBy: 18))).truncatingRemainder(dividingBy: Double(size.height + 40))) - 20
                let radius = 0.6 + (sin(seed + time * 1.4) * 0.5 + 0.5) * 1.8
                let alpha = 0.15 + (sin(seed * 3.7 + time * 0.9) * 0.5 + 0.5) * 0.55

                var path = Path()
                path.addEllipse(in: CGRect(x: x, y: y, width: radius * 2, height: radius * 2))
                context.fill(path, with: .color(particleColor.opacity(alpha)))
            }
        }
    }
}
