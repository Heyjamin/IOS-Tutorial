//
//  StarRatingView.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-09.
//

import SwiftUI

struct StarRatingView: View {
    let stars: Int
    var maxStars: Int = 5
    var size: CGFloat = 14
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxStars, id: \.self){ index in
                Image(systemName: index <= stars ? Const.starFillIcon : Const.starIcon)
                    .font(.system(size:size))
                    .foregroundColor(index <= stars ? .yellow : .gray.opacity(0.45))
            }
        }
    }
}

#Preview {
    StarRatingView(stars: 3)
        .padding()
        .background(Color.black)
}
