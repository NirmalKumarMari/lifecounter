//
//  ContentView.swift
//  lifecounter
//
//  Created by nrml on 1/29/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var life1 = 20
    @State private var life2 = 20
    
    var body: some View {
        VStack {
            HStack {
                playerView(name: "Player 1", life: $life1)
                
                playerView(name: "Player 2", life: $life2)
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
