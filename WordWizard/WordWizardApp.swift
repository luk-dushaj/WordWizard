//
//  WordWizardApp.swift
//  WordWizard
//
//  Created by user on 12/21/24.
//

import SwiftData
import SwiftUI

@main
struct WordWizardApp: App {
    @StateObject var vm = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .applyColorScheme(from: vm)
                .onAppear {
                    Task {
                        await vm.startup()
                    }
                }
        }
    }
}

extension View {
    func applyColorScheme(from vm: ViewModel) -> some View {
        Group {
            if let scheme = vm.resolveColorScheme() {
                self.environment(\.colorScheme, scheme)
            } else {
                // No color scheme applied, so the original view is returned
                self
            }
        }
    }
}
