//
//  GameView.swift
//  WordWizard
//
//  Created by user on 12/21/24.
//

import AVFoundation
import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var isGameActive: Bool
    @State private var currentQuestion: Int = 1
    @State private var correctAnswers: Int = 0
    @State private var userAnswer: String = ""
    @State private var exit: Bool = false
    @State private var finished: Bool = false
    @State private var errorMessage = ""
    @State private var correctAlert: Bool = false
    @State private var incorrectAlert: Bool = false
    @State private var isCorrect: Bool = false
    let synthesizer = AVSpeechSynthesizer()
    var body: some View {
        if isGameActive {
            VStack {
                HStack {
                    Text("Question: \(currentQuestion)")
                        .font(.title)
                    Spacer()
                    Button(
                        action: {
                            exit.toggle()
                            Task {
                                await vm.generateWords()
                            }
                        },
                        label: {
                            Text("Finish")
                                .font(.title)
                                .foregroundStyle(.red)
                        })
                }
                .padding()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Spell this word...")
                            .font(.title2)
                        Spacer(minLength: 0)
                        Text("Score: \(correctAnswers)/\(vm.totalQuestions)")
                            .font(.title2)
                    }
                }
                .padding()
                Spacer()
                Button(
                    action: {
                        // Run the voice activation with the word
                        let utterance = AVSpeechUtterance(
                            string: "\(vm.gameWords[currentQuestion - 1])")
                        utterance.voice = AVSpeechSynthesisVoice(
                            language: "en-US")
                        synthesizer.speak(utterance)
                    },
                    label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .scaleEffect(4)
                    }
                )
                .padding()
                Spacer()
                if errorMessage != "" {
                    Text(errorMessage)
                }
                TextField("Enter your answer", text: $userAnswer)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        errorHandling()
                    }
                Button(
                    action: {
                        errorHandling()
                    },
                    label: {
                        Text("Submit")
                            .font(.title3)
                            .foregroundStyle(.green)
                    })
            }
            .padding()
            .alert("Correct!", isPresented: $correctAlert) {
                Button("Ok") {
                    correctAlert.toggle()
                }
            }
            .alert("Incorrect!", isPresented: $incorrectAlert) {
                Button("Ok") {
                    incorrectAlert.toggle()
                }
            } message: {
                Text("The word was: \(vm.currentWord)")
            }
            .alert("The game has been quitted.", isPresented: $exit) {
                Button("OK") {
                    isGameActive.toggle()
                    Task {
                       await vm.generateWords()
                    }
                }
            } message: {
                Text(
                    """
                    Out of questions answered you scored: \(correctAnswers)/\(currentQuestion - 1)
                    You had \(vm.totalQuestions - currentQuestion + 1) questions remaining.
                    """)
            }
            .alert("You finished the game", isPresented: $finished) {
                Button("OK") {
                    isGameActive.toggle()
                    isCorrect = false
                    Task {
                       await vm.generateWords()
                    }
                }
            } message: {
                Text(
                    """
                    Out of questions answered you scored: \(correctAnswers)/\(vm.totalQuestions)
                    \(isCorrect ? "Last answer is correct" : "Last answer is incorrect, it's \(vm.currentWord)")
                    """)
            }
        } else {
            ContentView()
        }
    }
    func errorHandling() {
        print(vm.gameWords)
        // Validate user input
        if userAnswer.isEmpty || !userAnswer.contains(where: { $0.isLetter }) {
            errorMessage = "Please enter a valid word."
            return
        }

        errorMessage = ""
        vm.currentWord = vm.gameWords[currentQuestion - 1]

        let isAnswerCorrect = vm.checkWord(userAnswer.lowercased())

        if currentQuestion == vm.totalQuestions {
            if isAnswerCorrect {
                correctAnswers += 1
                isCorrect = true
            }
            finished.toggle()
            return
        } else {
            // Move to the next question
            currentQuestion += 1
        }

        // Show the correct or incorrect alert
        if isAnswerCorrect && currentQuestion <= vm.totalQuestions {
            correctAlert.toggle()
            correctAnswers += 1
        } else {
            incorrectAlert.toggle()
        }

        userAnswer = ""
    }
}

//#Preview {
//    GameView(isGameActive: .constant(true))
//}
