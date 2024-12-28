//
//  LoadingView.swift
//  WordWizard
//
//  Created by user on 12/27/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

#Preview {
    LoadingView()
}
