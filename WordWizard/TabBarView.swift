//
//  TabBarView.swift
//  WordWizard
//
//  Created by Luk Dushaj on 12/21/24.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @Binding public var selectionIndex: Int
    @Binding public var isGameActive: Bool

    var body: some View {
        TabView(selection: $selectionIndex) {
            VStack {
                if !isGameActive {
                    NavigationView {
                        // Show the button to start the game
                        Button(action: {
                            isGameActive.toggle()
                        }) {
                            Text("Start Game")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .navigationTitle("Word Wizard")
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            NavigationView {
                InfoView()
                    .navigationTitle("Word Wizard")
            }
            .tabItem {
                Image(systemName: "info.circle")
                Text("Info")
            }
            .tag(1)
            .disabled(isGameActive)

            NavigationView {
                SettingsView()
                    .navigationTitle("Word Wizard")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(2)
            .disabled(isGameActive)
        }
    }
}

//#Preview {
//    TabBarView(selectionIndex: .constant(0), isGameActive: .constant(false))
//}
