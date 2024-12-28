//
//  InfoItem.swift
//  WordWizard
//
//  Created by user on 12/21/24.
//

import SwiftUI

struct InfoType: View {
    public let title: String
    public let description: String
    @State private var showDescription = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                showDescription.toggle()
            }) {
                HStack {
                    Text(title)
                        .font(.title)
                        .bold()
                    Spacer(minLength: 0)
                    showDescription
                        ? Image(systemName: "arrow.down")
                            .scaleEffect(1.25)
                        : Image(systemName: "arrow.right")
                            .scaleEffect(1.25)
                }
            }
            .foregroundStyle(
                vm.resolveColorScheme() == nil && colorScheme == .light || vm.theme == "light"
                    ? .black : .white
            )
            if showDescription {
                HStack {
                    Text(description)
                    // Aligning it to the left to fit more space
                    Spacer(minLength: 0)
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    InfoItem(title: "YUH", description: "Cmon")
//}
