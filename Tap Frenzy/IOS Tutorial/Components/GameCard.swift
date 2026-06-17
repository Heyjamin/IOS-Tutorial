//
//  GameCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-17.
//

import SwiftUI

struct GameCard: View {
    let title: String
    let icon: String
    let description: String
    
    var body: some View {
        VStack(spacing:12){
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.neonBlue)
            
            Text(title)
                .font(.title3)
                .fontWeight(.black)
                .foregroundStyle(.white)
            
            Text(description)
                .foregroundColor(.gray)
        }
        .frame(maxWidth:.infinity)
        .padding()
        .glassCard()
        
    }
}
