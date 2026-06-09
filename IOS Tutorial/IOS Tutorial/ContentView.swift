//
//  ContentView.swift
//  IOS Tutorial
//
//  Created by student5 on 2026-06-06.
//

import SwiftUI

struct ContentView: View {
    
    @State private var number = 1
    var body: some View {
        VStack {
            // instantiate
            Text ("\(number)")
            
            //change text with button
            
            Button("Touch Me") {
                number += 1
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
