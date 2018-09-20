//
//  Concentration.swift
//  Concentration
//
//  Created by Kevin Andrew Warshaw on 7/7/18.
//  Copyright © 2018 Kevin Andrew Warshaw. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [Card]() // Array initializer
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var matchCount = 0
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): Chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matchCount += 2
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init (numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): You must have at least one pair of cards")
        //... range inclusive, ..< range exclusive
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            // card is a struct, each time it's passed as an argument it gets copied
            cards += [card, card]
        }
        shuffle(deck: cards)
    }
    
    mutating func shuffle(deck unshuffled: [Card]) {
        var occupiedIndices = [Bool](repeating: false, count: unshuffled.count)
        var shuffled = [Card]()
        for _ in unshuffled {
            let randomIndex = Int(arc4random_uniform(UInt32(unshuffled.count)))
            let chosenIndex = checkValidInsert(at: randomIndex, of: occupiedIndices)
            occupiedIndices[chosenIndex] = true
            shuffled.append(unshuffled[chosenIndex])
        }
        cards = shuffled
    }
    
    func checkValidInsert(at index: Int, of deck: [Bool]) -> Int {
        if deck[index] == false {
            return index
        }
        else {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            let finalIndex = checkValidInsert(at: randomIndex, of: deck)
            return finalIndex
        }
    }
    
    mutating func reset() {
        for index in 0..<cards.count {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        shuffle(deck: cards)
        matchCount = 0
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}









