//
//  ViewModel.swift
//  WordWizard
//
//  Created by Luk Dushaj on 12/22/24.
//

import Foundation
import SwiftUI

// Would do @Observable, but I find doing my typical actions harder as in keeping an @EnvironmentObject for clean reusability instead of passing one instance of the class around.
@MainActor
class ViewModel: ObservableObject {
    @AppStorage("selectedAppearance") public var theme: String = "system"

    func resolveColorScheme() -> ColorScheme? {
        switch theme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }

    @Published var mode: Mode = .random
    @Published var totalQuestions: Int = 5
    @Published var gameWords: [String] = []
    @Published public var isLoading: Bool = false

    var easyWords: [String] = []
    var mediumWords: [String] = []
    var hardWords: [String] = []
    let defaults = UserDefaults.standard
    var currentWord = ""

    /// Function that is for syncing the new data now and loading the new words based on that data
    func refresh() async {
        // Set loading state to true and ensure UI reflects it immediately
        DispatchQueue.main.async {
            self.isLoading = true
        }
        await saveData()
        await loadData()
        easyWords.removeAll()
        mediumWords.removeAll()
        hardWords.removeAll()
        gameWords.removeAll()
        await loadWordTypes()

        await generateWords()
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }

    /// Initial startup function
    func startup() async {
        DispatchQueue.main.async { self.isLoading = true }
        // Have to give the loading view time to appear
        try? await Task.sleep(nanoseconds: 100_000_000)
        await loadData()
        await loadWordTypes()
        await generateWords()
        DispatchQueue.main.async { self.isLoading = false }
    }

    /// Saves the current game data to `UserDefaults`
    func saveData() async {
        defaults.set(mode.rawValue, forKey: "mode")
        defaults.set(totalQuestions, forKey: "totalQuestions")
        defaults.set(theme, forKey: "selectedAppearance")
    }

    /// Loads game data from `UserDefaults`
    func loadData() async {
        let keys = defaults.dictionaryRepresentation().keys

        // Check if the keys exist before loading the values
        if keys.contains("totalQuestions") {
            totalQuestions = defaults.integer(forKey: "totalQuestions")
        } else {
            totalQuestions = 5
        }

        if keys.contains("mode"),
            let modeValue = defaults.string(forKey: "mode"),
            let mode = Mode(rawValue: modeValue)
        {
            self.mode = mode
        } else {
            self.mode = .random
        }

        if keys.contains("selectedAppearance") {
            theme = defaults.string(forKey: "selectedAppearance") ?? "system"
        } else {
            theme = "system"
        }
    }

    /// Adding extra checking with Apple's built in `UITextChecker()`
    func isCorrect(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.lowercased().utf8.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word.lowercased(), range: range, startingAt: 0, wrap: false,
            language: "en")
        return misspelledRange.location == NSNotFound
    }

    /// Checks if optimized word list is available
    func isFilteredListAvailable() -> URL? {
        let fileName = "filtered_words"
        let fileExtension = "txt"
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!
        let filteredFileURL = documentsDirectory.appendingPathComponent(
            "\(fileName).\(fileExtension)")

        return FileManager.default.fileExists(atPath: filteredFileURL.path)
            ? filteredFileURL : nil
    }

    /// Function that grabs words from word list
    func loadWordTypes() async {
        let fileName = "words"
        let fileExtension = "txt"
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!

        if let filteredFileURL = isFilteredListAvailable() {
            do {
                // Use the existing filtered file
                let content = try String(
                    contentsOf: filteredFileURL, encoding: .utf8)
                let lines = content.split(whereSeparator: \.isNewline)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }

                for word in lines {
                    if word.count <= 5 {
                        easyWords.append(word)
                    } else if word.count <= 8 && word.count >= 6 {
                        mediumWords.append(word)
                    } else if word.count >= 9 {
                        hardWords.append(word)
                    }
                }
            } catch {
                print("Error reading filtered file: \(error)")
            }
        } else {
            if let filePath = Bundle.main.path(
                forResource: fileName, ofType: fileExtension)
            {
                do {
                    let content = try String(
                        contentsOfFile: filePath, encoding: .utf8)

                    let lines = content.split(whereSeparator: \.isNewline)
                        .map {
                            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        .filter { !$0.isEmpty }

                    var correctWordList: [String] = []

                    for baseWord in lines {
                        let word = String(baseWord)
                        if isCorrect(word: word) {
                            correctWordList.append(word)

                            if word.count <= 5 {
                                easyWords.append(word)
                            } else if word.count <= 8 && word.count >= 6 {
                                mediumWords.append(word)
                            } else if word.count >= 9 {
                                hardWords.append(word)
                            }
                        }
                    }

                    let updatedContent = correctWordList.joined(separator: "\n")
                    let filteredFileURL =
                        documentsDirectory.appendingPathComponent(
                            "filtered_words.txt")

                    try updatedContent.write(
                        to: filteredFileURL, atomically: true, encoding: .utf8)

                    print("Filtered words saved to \(filteredFileURL.path)")
                } catch {
                    print("Error reading or writing file: \(error)")
                }
            } else {
                print("File not found.")
            }
        }
    }

    /// Returns array of random words
    func randomWords() async -> [String] {
        var words = [String]()
        var wordsArray = [String]()

        for _ in 0..<totalQuestions {
            let randomNumber = Int.random(in: 0...2)

            switch randomNumber {
            case 0:
                wordsArray = easyWords
            case 1:
                wordsArray = mediumWords
            case 2:
                wordsArray = hardWords
            default:
                wordsArray = easyWords
            }
            if let word = generateUniqueRandom(
                from: wordsArray, excluding: words)
            {
                words.append(word)
            }
        }

        return words
    }

    /// Function to generate words based on game mode
    func generateWords() async {
        var modeArray = [String]()

        if !gameWords.isEmpty {
            gameWords = []
        }

        switch mode {
        case .easy:
            modeArray = easyWords
        case .medium:
            modeArray = mediumWords
        case .hard:
            modeArray = hardWords
        case .random:
            gameWords = await randomWords()
            return
        }

        guard !modeArray.isEmpty else {
            print("Error: Mode array is empty. Cannot generate words.")
            return
        }

        for _ in 0..<totalQuestions {
            if let word = generateUniqueRandom(
                from: modeArray, excluding: gameWords)
            {
                gameWords.append(word)
            }
        }
    }

    /// Generates a unique random word from the given array
    func generateUniqueRandom(
        from array: [String], excluding usedElements: [String]
    ) -> String? {
        guard !array.isEmpty else {
            print(
                "Warning: Array is empty while generating a unique random word."
            )
            return nil
        }

        let randomElement = array.randomElement()!
        if usedElements.contains(randomElement) {
            return generateUniqueRandom(from: array, excluding: usedElements)
        }
        return randomElement
    }

    /// Checks if the word exists in the game words
    func checkWord(_ word: String) -> Bool {
        gameWords.contains(word)
    }
}
