//
//  SettingsView.swift
//  WordWizard
//
//  Created by Luk Dushaj on 12/21/24.
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
    var body: some View {
        if vm.isLoading {
            LoadingView()
        } else {
            VStack {  // Controls spacing between elements
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
                    Picker("Select Theme", selection: $vm.theme) {
                        Text("System Default").tag("system")
                        Text("Light Mode").tag("light")
                        Text("Dark Mode").tag("dark")
                    }
                    Button(
                        action: {
                            Task {
                                await vm.refresh()
                            }
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
