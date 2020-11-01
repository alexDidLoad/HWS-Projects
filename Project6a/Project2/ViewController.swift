//
//  ViewController.swift
//  Project2
//
//  Created by Alexander Ha on 9/18/20.
//  Copyright © 2020 Alexander Ha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsCap = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 0.5
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderWidth = 0.5
        button2.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderWidth = 0.5
        button3.layer.borderColor = UIColor.black.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Score", style: .plain, target: self, action: #selector(showScoreTapped))
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        presentFinalScore()
        title = countries[correctAnswer].uppercased()
        questionsCap += 1
    }
    
    func presentFinalScore() {
        if questionsCap == 10 {
            let title: String = "Your Final Score is:"
            let ac = UIAlertController(title: title, message: "\(score) /10", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start Over", style: .default, handler: nil))
            present(ac, animated: true)
            score = 0
            questionsCap = 0
        } else {
            return
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        var message: String
        if sender.tag == correctAnswer {
            title = "Correct"
            message = "Good job! That is indeed the flag of \(countries[sender.tag].uppercased())"
            score += 1
        } else {
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func showScoreTapped() {
        
        let alertController = UIAlertController(title: "Score", message: "\(score)/10", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    
    
}

