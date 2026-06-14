//
//  GlassCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-14.
//

import SwiftUI

struct GlassCard: ViewModifier {
func body(content: Content) -> some View {
        content
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    Color.white.opacity(0.15),
                    lineWidth: 1
                )
        )
                
    }

}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}
