//
//  ContentView.swift
//  lifecounter
//
//  Created by nrml on 1/29/26.
//

import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var life: Int = 20
}

struct ContentView: View {
    
    @State private var players = [Player(name: "Player 1"), Player(name: "Player 2"), Player(name: "Player 3"), Player(name: "Player 4")]
    @State private var start = false
    @State private var history:[String] = []
    
    func addPlayer() {
        if !start {
            if players.count < 8 {
                players.append(Player(name: "Player \(players.count + 1)"))
                history.append("\(Player(name: "Player \(players.count)").name) has been added.")
            }
        }
    }
    func removePlayer() {
        if !start {
            if players.count > 2 {
                players.removeLast()
                history.append("\(Player(name: "Player \(players.count)").name) has been removed.")
            }
        }
    }
    
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    
    var gameOver: Bool {
        players.filter { $0.life > 0 }.count <= 1
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    HStack{
                        HStack{
                            Button("Remove Player") {removePlayer()}
                            Button("Add Player") {addPlayer()}
                        }
                        .disabled(start)
                        NavigationLink{
                            History(history: history)
                        } label: {
                            Text("History")
                        }
                    }
                    .buttonStyle(.bordered)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach($players) { $player in
                            PlayerView(
                                name: $player.name, life: $player.life,
                                start: $start,
                                history: $history)
                        }
                    }
                    Button("Reset"){
                        
                        if players.count > 4 {
                            players.removeLast(players.count - 4)
                        } else if players.count < 4 {
                            for _ in 0..<((players.count - 4) * -1) {
                                
                                addPlayer()
                                
                            }
                        }
                        
                        for i in 0..<players.count {
                            players[i].life = 20
                            players[i].name = "Player \(i+1)"
                        }
                        start = false
                        history = []
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .overlay {
                    if gameOver && start {
                        VStack(spacing: 16) {
                            Text("Game over!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Button("OK") {
                                
                                if players.count > 4 {
                                    players.removeLast(players.count - 4)
                                } else if players.count < 4 {
                                    for _ in 0..<((players.count - 4) * -1) {
                                        
                                        addPlayer()
                                        
                                    }
                                }
                                
                                for i in 0..<players.count {
                                    players[i].life = 20
                                }
                                start = false
                                history = []
                            }
                            .buttonStyle(.bordered)
                        }
                        .background(.ultraThinMaterial)
                        .padding()
                        
                    }
                }
            }
            
        }
        
    }
}



struct PlayerView: View {
    @Binding var name: String
    @Binding var life: Int
    @State private var del: String = "5"
    @Binding var start: Bool
    @Binding var history: [String]
    @State private var showEditName = false
    @State private var editedName = ""
    
    var body: some View {
        VStack(spacing: 20){
            Button {
                editedName = name
                showEditName = true
            } label: {
                Text(name)
                    .font(.title2)
                    .foregroundColor(.black)
            }


            HStack{
                Button("-") {life -= 1; history.append("\(name) lost 1 life."); start = true}
                Text("\(life)")
                    .font(.largeTitle)
                Button("+") {life += 1; history.append("\(name) gained 1 life."); start = true}
            }
            .buttonStyle(.bordered)
            HStack{
                Button("-") {life -= Int(del) ?? 0; history.append("\(name) lost \( Int(del) ?? 0) life."); start = true}
                TextField("Amount", text: $del)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                Button("+") {life += Int(del) ?? 0; history.append("\(name) gained \( Int(del) ?? 0) life."); start = true}
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Edit Player Name", isPresented: $showEditName) {
            TextField("Name", text: $editedName)

            Button("Save") {
                let oldName = name
                    let newName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)

                    guard !newName.isEmpty, newName != oldName else { return }

                    name = newName
                    history.append("\(oldName) changed their name to \(newName).")
            }

            Button("Cancel", role: .cancel) { }
        }

        
    }
}

struct History: View {
    let history: [String]

    var body: some View {
        List {
            
            if history.isEmpty {
                Text("No History Yet.")
            } else {
                ForEach(history.indices, id: \.self) { i in
                    Text(history[i])
                }
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    ContentView()
}
