//
//  ViewController.swift
//  Project 5
//
//  Created by Alexander Ha on 9/22/20.
//  Copyright © 2020 Alexander Ha. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        checkCurrentWord()
        checkEntries()
        
        if title == "" {
            startGame()
        } else {
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        saveEntries()
        saveCurrentWord()
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    //MARK: - submit method
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        guard isPossible(word: lowerAnswer) else {
            showErrorMessage(title: "Word not recognized", message: "You can't do dat")
            return
        }
        guard isOriginal(word: lowerAnswer) else {
            showErrorMessage(title: "Word already used", message: "You really tried it")
            return
        }
        guard isReal(word: lowerAnswer) else {
            showErrorMessage(title: "Word isn't real", message: "You can't spell that word from \(title!.lowercased())")
            return
        }
        usedWords.insert(answer, at: 0)
        saveEntries()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    //MARK: - isPossible method
    
    func isPossible(word: String) -> Bool {
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
    //MARK: - isOriginal method
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    //MARK: - isReal method
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRanged = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.count < 3 {
            return false
        } else if title == word {
            return false
        } else {
            return misspelledRanged.location == NSNotFound
        }
    }
    //MARK: - showErrorMessage method
    
    func showErrorMessage(title: String, message: String) {
        let errorTitle = title
        let errorMessage = message
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - Save and Check methods
    
    
    func saveCurrentWord() {
        defaults.set(title, forKey: UserKeys.currentWord)
    }
    
    func checkCurrentWord() {
        let word = defaults.value(forKey: UserKeys.currentWord) as? String ?? ""
        title = word
    }
    
    func saveEntries() {
        defaults.set(usedWords, forKey: UserKeys.currentEntries)
    }
    
    func checkEntries() {
        let previousEntries = defaults.array(forKey: UserKeys.currentEntries) as? [String] ?? [String]()
        usedWords = previousEntries
    }
    
    
}

