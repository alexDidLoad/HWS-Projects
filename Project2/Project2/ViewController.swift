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
    var highScore = 0
    var score = 0
    var correctAnswer = 0
    var questionsCap = 0
    let defaults = UserDefaults.standard
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Score", style: .done, target: self, action: #selector(showScoreTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "High Score", style: .done, target: self, action: #selector(showHighScore))
        
        checkForHighScore()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: []) {
            self.button1.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.button2.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.button3.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.button1.setImage(UIImage(named: self.countries[0]), for: .normal)
            self.button2.setImage(UIImage(named: self.countries[1]), for: .normal)
            self.button3.setImage(UIImage(named: self.countries[2]), for: .normal)
        } completion: { finished in }
        presentFinalScore()
        title = countries[correctAnswer].uppercased()
        questionsCap += 1
    }
    
    func presentFinalScore() {
        
        if questionsCap == 15 {
            //saves score
            if score > highScore {
                highScore = score
                beatsPreviousScore()
                saveScore()
                
            } else if score <= highScore {
                finalScoreAlert()
            }
            //resets score and questionCap
            score = 0
            questionsCap = 0
        } else {
            return
        }
    }
    
    func finalScoreAlert() {
        
        let ac = UIAlertController(title: "Your Final Score is:", message: "\(score) /15", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start Over", style: .default))
        present(ac, animated: true)
        
    }
    
    func beatsPreviousScore() {
        let ac = UIAlertController(title: "New Highscore!", message: "Your new highscore is: \(highScore) ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
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
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        //add animation when UIButton is pressed
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { finished in
            self.present(ac, animated: true)
        }
      
    }
    
    //MARK: - Obj-c Methods
    
    @objc func showScoreTapped() {
        
        let alertController = UIAlertController(title: "Score", message: "\(score)/15", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    @objc func showHighScore() {
        
        let alertController = UIAlertController(title: "High Score", message: "\(highScore)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
        
    }
    
    
    //MARK: - Saving and Loading UserDefaults
    
    func saveScore() {
        defaults.set(highScore, forKey: Keys.previousHighScore)
    }
    
    func checkForHighScore() {
        
        let previousScore = defaults.integer(forKey: Keys.previousHighScore)
        highScore = previousScore
    }
    
    
    
}

