//
//  ViewController.swift
//  Apple Pie 2021
//
//  Created by Евгений Гуляев on 07.06.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var listOfWords = [
        "Москва",
        "Владимир",
        "Тверь"
    ]
    var totalWins = 0
    var totalLoses = 0
    
    // MARK: - Methods
    func newRound() {
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed)
        updateUI()
    }
    
    func updateCorrectWord() {
        var displayWord = [String]()
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
//        let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7
        let imageNumber = (movesRemaining + 64) % 8
        let image = "Tree\(imageNumber)"
        treeImageView.image = UIImage(named: image)
        updateCorrectWord()
        scoreLabel.text = "Выигрыши: \(totalWins), проигрыши: \(totalLoses)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }

    // MARK: - IB Actions
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuessed(letter: Character(letter))
        updateUI()
    }
}

