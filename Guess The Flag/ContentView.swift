//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Adam Sayer on 21/7/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore: Int = 0
    @State private var numberOfQuestions: Int = 0
    
    @State private var selectedFlag = -1
    
    struct FlagFormat: View {
        var country: String

        var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue:0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue:0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagFormat(country: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? 360 : 0), axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                        .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                        .animation(.default, value: selectedFlag)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(totalScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                
                Text("Questions left \(8 - numberOfQuestions)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if numberOfQuestions == 8 {
                Button("Restart", action: askQuestion)
            } else {
                Button("Continue", action: askQuestion)
            }
        } message: {
            if numberOfQuestions == 8 {
                Text("Well done, that's the end of the game.  You scored \(totalScore)")
            } else {
                Text("Your Score is \(totalScore)")
            }
        }
    }
    
    func flagTapped (_ number: Int) {
        
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
            numberOfQuestions += 1
        } else {
            scoreTitle = "Wrong, thats the flag of \(countries[number])"
            numberOfQuestions += 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if numberOfQuestions == 8 {
            numberOfQuestions = 0
            totalScore = 0
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        
        selectedFlag = -1
    }
}

#Preview {
    ContentView()
}
