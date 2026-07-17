//
//  ScoreBadge.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct ScoreBadge: View {
    let title: String
    let score: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 6){
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(score)")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        ScoreBadge(title: Const.txtScore.uppercased(), score: 47, color: .neonGreen)
            .padding()
    }
}
