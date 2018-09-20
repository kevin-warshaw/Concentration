//
//  ViewController.swift
//  Concentration
//
//  Created by Kevin Andrew Warshaw on 6/28/18.
//  Copyright © 2018 Kevin Andrew Warshaw. All rights reserved.
//

// Can fall through switch-case with "fallthrough" keyword (lookup for syntax)
import UIKit

class ViewController: UIViewController
{
    //Cannot use didSets with lazy, use lazy to initialize when called instaed of with init, self needed in this case to kill error
    private lazy var game = Concentration(numberOfPairsOfCards: self.numberOfPairsOfCards)
    
    // \() used as String.Format({x}, val) in c#, just put variable name directly inside
    private(set) var flipCount = 0 {
        didSet {
            UpdateFlipCountLabel()
        }
    }
    
    private func UpdateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            UpdateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]! // Connected with control drag from yellow viewController in main storyboard to each button
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons.")
        }
    }
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
        flipCount = 0
        newGameButton.isHidden = true
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal) // Normal is the default state
                if card.isMatched {
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    if game.matchCount == cardButtons.count {
                        newGameButton.isHidden = false
                    }
                }
                else {
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
    }
    
    private var emoji = [Card:String]() // Dictionary declaration

    //private var emojiChoices = ["💩","👻","🌚","👽","💀","🤡","🎃","👹","🤠"]
    private var emojiChoices = "💩👻🌚👽💀🤡🎃👹🤠"
    
    private func emoji(for card: Card) -> String {
        // Back-to-back ifs can go on the same line if separated by a comma
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomIndex))
        }
        // ?? is used to determine if optional value exists, runs left is so or right if not
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) // Not inclusive
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

