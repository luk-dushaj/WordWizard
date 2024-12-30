//
//  InfoView.swift
//  WordWizard
//
//  Created by Luk Dushaj on 12/21/24.
//

import SwiftUI

// View which basically serves as a FAQ/how to use certain features in the app

struct InfoView: View {
    @State private var showWordlist = false
    @State private var showSource = false
    let infoItems = [
        InfoItem(
            title: "How to play",
            description:
                "Once you click start you will see a blue speaker icon on the screen. When you click that you will hear the word and you have to spell that word in the input box below. Then it's pretty simple you will get a point if correct and not if it's wrong. Ideally you should try to complete all the questions but you can always exit by clicking the \"Finish\" button."
        ),
        InfoItem(
            title: "Gameplay Options",
            description:
                "As you will see when you go to the Settings screen, there are various options to modify the game. You can select different modes, modify the question amount, you can turn on case sensitivity and even change the theme of the app. I will go over a few of those below."
        ),
        InfoItem(
            title: "What is a mode?",
            description:
                "A mode is basically the difficulty of the words generated. The 3 main ones easy, medium and hard are very self explanatory. Easy will generate words with 5 or less letter words, medium will generate words with 8-6 letter words and hard will generate words with 9+ letters. Lastly, random is just random."
        ),
        InfoItem(
            title: "Settings",
            description:
                "In settings you can also change the theme of the app and the total amount of questions in the game. Below all of that will be a Save Changes button which will save your changes for next time you open the app. I HIGHLY recommend you always press the save changes button so you don't get any unexpected functionality. Have fun!"
        ),
        InfoItem(
            title: "Why the long wait for the first app open?",
            description:
                "This all depends on your iPhone model. I am using a wordlist from GitHub that is over 4MB in size. So the program is very heavily parsing and filtering any non real words. But once it is done the list is updated and loading will be really fast."
        )
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(infoItems, id: \.id) { infoItem in
                    InfoType(
                        title: infoItem.title, description: infoItem.description
                    )
                }
            }
            VStack(spacing: 20) {
                Text("Wordlist")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .onTapGesture {
                        showWordlist = true
                    }
                Text("Source")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .onTapGesture {
                        showSource = true
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .sheet(isPresented: $showWordlist) {
                WebView(
                    url: URL(string: "https://github.com/dwyl/english-words")!)
            }
            .sheet(isPresented: $showSource) {
                WebView(
                    url: URL(string: "https://github.com/luk-dushaj/WordWizard")!)
            }
            .frame(
                minWidth: 0, maxWidth: .infinity, minHeight: 0,
                maxHeight: .infinity, alignment: .topLeading
            )
        }
    }
}

#Preview {
    InfoView()
}
