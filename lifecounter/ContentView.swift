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
            Spacer()
            
            if (life1 <= 0) {
                Text("Player 1 LOSES!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            else if (life2 <= 0) {
                Text("Player 2 LOSES!")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding()
    }
}

struct playerView: View {
    let name: String
    @Binding var life: Int
    
    var body: some View {
        VStack(spacing: 20){
            Text(name)
                .font(.title2)
            Text("\(life)")
                .font(.largeTitle)
            
            
            HStack{
                Button("-5") {life -= 5}
                Button("-") {life -= 1}
                Button("+") {life += 1}
                Button("+5") {life += 5}
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        
    }
}
#Preview {
    ContentView()
}
