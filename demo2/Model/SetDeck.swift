//
//  SetDeck.swift
//  demo2
//
//  Created by cc on 2022/4/15.
//

import Foundation

class SetGame
{
    private(set) var cards = [Card]()
    
    private(set) var selectedCards = [Card]()
    private(set) var tableCards = [Card]()
    
    private(set) var score = 0
    
    var hintCards = [Int]()
    
    init() {
        for number in Card.Number.all {
            for shape in Card.Shape.all {
                for color in Card.ShapeColor.all {
                    for shading in Card.Shading.all {
                        cards.append(Card(number: number, color: color, shape: shape, shading: shading))
                    }
                }
            }
        }
    }
    
    func hint(on showedCards: [Card]) {
        hintCards.removeAll()
        let f = showedCards.count.arc4racndom
        let firstCard = showedCards[f]
    outerLoop: for i in 0..<showedCards.count {
            for j in i+1..<showedCards.count {
                let hint = [firstCard, showedCards[i], showedCards[j]]
                if isSet(on: hint) {
                    hintCards += [f, i, j]
                    break outerLoop
                }
            }
        }
    }
    
    private func isSet(on selectedCards: [Card]) -> Bool {
        let number = Set(selectedCards.map { $0.number }).count
        let color = Set(selectedCards.map { $0.color }).count
        let shape = Set(selectedCards.map { $0.shape }).count
        let shading = Set(selectedCards.map { $0.shading }).count
        
        return number != 2 && color != 2 && shape != 2 && shading != 2
    }
    
    func dealCards(forAmount amount: Int = 3) {
        var moreCards = [Card]()
        for _ in 1...amount {
            if let card = draw() {
                moreCards.append(card)
            }
        }
        
        if !selectedCards.isEmpty, selectedCards.count == 3 {
            selectedCards.forEach {
                if let index = tableCards.firstIndex(of: $0) {
                    tableCards[index] = moreCards.remove(at: moreCards.count.arc4racndom)
                }
            }
        } else {
            tableCards += moreCards
        }
    }
    
    func selectCard(at index: Int) {
        let card = tableCards[index]
        
        if let index = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: index)
        } else {
            selectedCards.append(card)
        }
        
        if selectedCards.count == 3 {
            if isSet(on: selectedCards) {
                dealCards()
                selectedCards = []
                score += 4
            } else {
                score -= 2
                selectedCards = []
            }
        }
    }
    
    func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4racndom)
        } else {
            return nil
        }
    }
    
    func rest() {
        tableCards = []
        selectedCards = []
        score = 0
        hintCards = []
        cards = []
    }
}

extension Int {
    var arc4racndom: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
