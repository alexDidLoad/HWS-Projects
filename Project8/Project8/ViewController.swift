//
//  ViewController.swift
//  Project8
//
//  Created by Alexander Ha on 9/29/20.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var letterBits = [String]()
    
    var clueString = ""
    var solutionString = ""
    var level = 1
    var realScore = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.backgroundColor = .white
        currentAnswer.layer.cornerRadius = 25
        currentAnswer.layer.borderWidth = 2.0
        currentAnswer.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            //pins scoreLabel's top anchor to the view margin's top anchor
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            //pins scoreLabel's trailing anchor to teh view margin's trailing anchor
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            //pins clueLabel's top anchor to the scoreLabel's bottom anchor
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            //pin the leading edge of the clue's label to the leading edge of layout margins, while adding 100 points for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            //makes the clues label 60% of the width of our layout margins, minus 100 points
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            //pins top of answers label to the bottom of scoreLabel
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            //pins answerLabel to the trailing edge of our layout margins, minus 100 points
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            //make the answersLabel take up 40% of the available space, minus 100 points
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            //makes the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            //places the currentAnswer textField center of the view
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //changes the width of currentAnswer textField to be 50% of the view's width
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            //pins the currentAnswer textField's top anchor to the clueLabel's bottom anchor, with 20 points of spacing
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            //sets clearButton's center Y anchor to match the submitButtons center Y Anchor so that the clearButton will always be aligned with the submitButtons Y anchor. This will ensure that both buttons will be aligned even if we move one
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        //for loop that creates 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                //create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                //give the button some temporary text in order to see it on screen
                letterButton.setTitle("WWW", for: .normal)
                //calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                //adding thin line around buttons view
                letterButton.layer.borderWidth = 2.0
                letterButton.layer.borderColor = UIColor.darkGray.cgColor
                //makes the buttons rounded
                letterButton.layer.cornerRadius = 10
                //sets button background color
                letterButton.backgroundColor = .white
                //add it to the buttons view
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
        performSelector(onMainThread: #selector(updateLabels), with: nil, waitUntilDone: false)
        performSelector(onMainThread: #selector(setTitles), with: nil, waitUntilDone: false)
    }
    
     func loadLevel() {
        
        performSelector(inBackground: #selector(parseLevel), with: nil)
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: []) {
            sender.alpha = 0.0
        }
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            realScore += 1
            
            if realScore % 7 == 0 {
                let ac = UIAlertController(title: "Well Done", message: "Are you ready for the next level?!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's GET IT BABY!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: nil, message: "That's not quite right", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default))
            present(ac, animated: true)
            score -= 1
            
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for btn in activatedButtons {
            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                btn.alpha = 1
            }
        }
        
        activatedButtons.removeAll()
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        loadLevel()
        for btn in letterButtons{
            btn.isHidden = false
        }
        performSelector(onMainThread: #selector(updateLabels), with: nil, waitUntilDone: false)
        performSelector(onMainThread: #selector(setTitles), with: nil, waitUntilDone: false)
        solutions.removeAll(keepingCapacity: true)
    }
    
    @objc func parseLevel() {
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try?String(contentsOf: levelFileURL) {
                var lines = levelContents.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                lines.shuffle()
                
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]
                        
                        self.clueString += "\(index + 1). \(clue)\n"
                        
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        self.solutionString += "\(solutionWord.count) Letter word\n"
                        self.solutions.append(solutionWord)
                        
                        let bits = answer.components(separatedBy: "|")
                        self.letterBits += bits
                }
            }
        }
    }
    
    @objc func updateLabels() {
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc func setTitles() {
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
}

