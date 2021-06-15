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
    @IBOutlet weak var hintLabel: UILabel!
    
    
    // MARK: - Properties
    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var listOfWords = [
        ["Урок", "Форма организации обучения с целью овладения учащимися изучаемым материалом"],
        ["Перемена", "Перерыв между уроками"],
        ["Ученик", "Тот, кто учится в школе или обучается какой-нибудь профессии"],
        ["Учитель", "Лицо, которое обучает чему-нибудь, преподаватель"],
        ["Рабочая программа", "Документ, составленный лично педагогом и являющийся частью базисного учебного плана"],
        ["Воспитание", "Навыки поведения, привитые школой, семьёй, средой и проявляющиеся в общественной жизни"],
        ["Обучение", "Процесс, в результате которого учащиеся под руководством учителя овладевают знаниями, умениями и навыками"],
        ["Дидактика", "Раздел педагогики и теории образования, изучающий проблемы обучения"],
        ["Курс", "Годичная ступень образования в высшей школе и в специальных учебных заведениях"],
        ["Лекция", "Устное изложение учебного предмета или какой-нибудь темы"],
        ["Упражнение", "Повторное выполнение действия с целью его усвоения"],
        ["Педагогика", "Наука о законах воспитания и образования человека"],
        ["Рефлексия", "Мыслительный процесс, направленный на самопознание, анализ своих эмоций и чувств"],
        ["Навык", "Уменье, созданное упражнениями, привычкой"],
        ["Метод", "Способ теоретического исследования или практического осуществления чего-либо"],
        ["Знания", "Форма существования и систематизации результатов познавательной деятельности человека"],
        ["Кружок", "Небольшое общество или тематический клуб по интересам"]
    ].shuffled()
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLoses = 0 {
        didSet {
            newRound()
        }
    }
    
    // MARK: - Methods
    
    private func enableButtons(_ enable: Bool = true) {
        for buttons in letterButtons {
            buttons.isEnabled = enable
        }
    }
    
    private func newRound() {
        guard !listOfWords.isEmpty else {
            enableButtons(false)
            updateUI()
            return
        }
        let newWord = listOfWords.removeFirst()
        
        currentGame = Game(word: newWord[0], hint: newWord[1], incorrectMovesRemaining: incorrectMovesAllowed)
        hintLabel.isHidden = true
        updateUI()
        enableButtons()
    }
    
    private func updateCorrectWord() {
        var displayWord = [String]()
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    private func updateState() {
        if currentGame.incorrectMovesRemaining < 1 {
            totalLoses += 1
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    private func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
//        let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7
        let imageNumber = (movesRemaining + 64) % 8
        let image = "Tree\(imageNumber)"
        hintLabel.text = currentGame.hint
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
        if letter != "?" {
            currentGame.playerGuessed(letter: Character(letter))
        } else {
            hintLabel.isHidden = false
            updateUI()
        }
        updateState()
    }
}

