//
//  Untitled.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-14.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let color : Color
    let icon: String
    
    var body: some View {
        VStack(spacing:8){
            Image (systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
