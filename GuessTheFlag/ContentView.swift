//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fred Tsui on 3/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var selectedFlag = 0
    @State private var questionCount = 1
    @State private var isGameOver = false

    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            scoreTitle = "Wrong"
            selectedFlag = number
        }
        if questionCount < 8 {
            showingScore = true
        } else {
            isGameOver = true
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCount += 1
    }
    
    func resetGame(){
        askQuestion()
        questionCount = 1
        playerScore = 0
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of:")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 15)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(playerScore)")
                    .foregroundStyle(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                Spacer()
                Text("Question Count: \(questionCount)")
                    .foregroundStyle(.white)
            }
            .padding()
        
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Correct" {
                Text("Your Score is \(playerScore)")
            } else {
                Text("You chose the flag of \(countries[selectedFlag])")
                Text("Your Score is still \(playerScore)")
            }
        }
        
        .alert("Game Over", isPresented: $isGameOver){
            Button("Restart", action: resetGame)
        } message: {
            switch playerScore {
            case 0...3:
                Text("""
                     You only got \(playerScore) correct.
                     You need more practice.
                     """)
            case 4...6:
                Text("""
                     You got \(playerScore) correct.
                     You are getting the hang of it.
                    """)
            case 7...8:
                Text("""
                     Congrats! You got \(playerScore) correct.
                     You are a master!
                    """)
            default:
                Text("What just happened?")
            }
        }
    }
}

#Preview {
    ContentView()
}
