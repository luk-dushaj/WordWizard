//
//  ContentView.swift
//  WordWizard
//
//  Created by Luk Dushaj on 12/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionIndex = 0
    @State private var isGameActive = false
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        if vm.isLoading {
            LoadingView()
        } else {
            NavigationView {
                if !isGameActive {
                    TabBarView(
                        selectionIndex: $selectionIndex,
                        isGameActive: $isGameActive
                    )
                } else {
                    GameView(isGameActive: $isGameActive)
                        .onAppear {
                            vm.gameWords.removeAll()
                            Task {
                                // Ensuring game words are refreshed
                                await vm.generateWords()
                            }
                        }
                        .navigationTitle("Word Wizard")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
