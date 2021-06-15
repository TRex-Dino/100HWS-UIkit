//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Dmitry on 15.06.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    @IBOutlet var scoreButton: UIBarButtonItem!
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var score = 0
    var correctAnswer = 0
    var totalQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreButton.tintColor = .black
        
        setView()
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let userAnswer = sender.tag
        totalQuestion += 1
        if userAnswer == correctAnswer {
            score += 1
            totalQuestion == 10 ? tenQuestion() : showAlert("Correct!")
        } else {
            score -= 1
            totalQuestion == 10 ? tenQuestion() : showAlert("Wrong! This is \(countries[userAnswer])")
        }
        scoreButton.title = "Score: \(score)"
    }
    

    private func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    private func setView() {
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func showAlert(_ title: String) {
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    private func tenQuestion() {
        showAlert("You answered 10 question")
        score = 0
        totalQuestion = 0
    }
}

