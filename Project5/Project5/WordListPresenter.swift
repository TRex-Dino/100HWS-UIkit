//
//  WordListPresenter.swift
//  Project5
//
//  Created by Меньков Д.В. on 20/11/22.
//

import UIKit

protocol WordListPresenter: AnyObject {
    func startGame()
    func setupAllWords()
    func submit(_ answer: String)
}

final class WordListPresenterImpl {
    
    private var allWords = [String]()
    private var usedWords = [String]()
    private var title: String?
    
    weak var view: WordListView?
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    private func isSame(word: String) -> Bool {
        return word == title
    }
}

extension WordListPresenterImpl: WordListPresenter {
    
    // MARK: - WordListPresenter
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        view?.restartView(with: title, and: usedWords)
    }
    
    func setupAllWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["shoking", "loved", "rambo", "norris"]
        }
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        if isSame(word: lowerAnswer) {
            view?.showErrorMessage(errorTitle: "Pff! Word is the same!",
                             errorMessage: "Don't cheat on me!")
        } else {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        let indexPath = IndexPath(row: 0, section: 0)
                        usedWords.insert(lowerAnswer, at: 0)
                        view?.updateView(words: usedWords, indexPath: indexPath)
                        return
                    } else {
                        view?.showErrorMessage(errorTitle: "Word not recognised or less than 3 letters", errorMessage: "You can't just make them up, you know!")
                    }
                } else {
                    view?.showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
                }
            } else {
                guard let title = title?.lowercased() else { return }
                view?.showErrorMessage(errorTitle: "Word not possible or less than 3 letters", errorMessage: "You can't spell that word from \(title)")
            }
        }
        
        
    }
    
}
