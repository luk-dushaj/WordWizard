//
//  SettingsView.swift
//  WordWizard
//
//  Created by user on 12/21/24.
//

import SwiftData
import SwiftUI

/*
 Default mode (4 option picker)

 Default amount of questions (mayber picker as well but probably input box)

 Case sensititivity check box

 Optional light/dark mode
 */

struct SettingsView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var changed = false
    @State private var message = ""
    var body: some View {
        if vm.isLoading {
            LoadingView()
        } else {
            VStack {  // Controls spacing between elements
                // Slightly below the form
                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)  // Optional: highlight message
                        .multilineTextAlignment(.center)
                }
                Form {
                    Picker("Select Mode", selection: $vm.mode) {
                        ForEach(Mode.allCases, id: \.self) { mode in
                            Text(mode.rawValue)
                                .tag(mode)
                        }
                    }
                    Stepper(
                        value: $vm.totalQuestions, in: 5...1000, step: 5,
                        label: {
                            Text("Questions: \(vm.totalQuestions)")
                        })
                    Toggle(isOn: $vm.casesensitive) {
                        Text("Case Sensitive")
                    }
                    .toggleStyle(.switch)
                    .onChange(of: vm.casesensitive) {
                        changed = true
                        message =
                            "Please click save changes in order for this feature to fully work."
                    }
                    Picker("Select Theme", selection: $vm.theme) {
                        Text("System Default").tag("system")
                        Text("Light Mode").tag("light")
                        Text("Dark Mode").tag("dark")
                    }
                    Button(
                        action: {
                            message = ""
                            Task {
                                await vm.refresh(casesensitive: changed)
                            }
                            changed = false
                        },
                        label: {
                            Text("Save Changes")
                        })
                }
            }
        }
    }
}
//#Preview {
//    SettingsView()
//}
