//
//  SetDeck.swift
//  demo2
//
//  Created by cc on 2022/4/15.
//

import Foundation

struct SetDeck
{
    private(set) var cards = [Card]()
    
    var selectedCards = [Card]()
    var tableCards = [Card]()
    
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
    
    mutating func hint(on showedCards: [Card]) {
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
    
    func isSet(on selectedCards: [Card]) -> Bool {
        let number = Set(selectedCards.map { $0.number }).count
        let color = Set(selectedCards.map { $0.color }).count
        let shape = Set(selectedCards.map { $0.shape }).count
        let shading = Set(selectedCards.map { $0.shading }).count
        
        return number != 2 && color != 2 && shape != 2 && shading != 2
    }
    
    mutating func dealCards() -> [Card] {
        var moreCards = [Card]()
        for _ in 1...3 {
            if let card = draw() {
                moreCards.append(card)
            }
        }
        return moreCards
    }
    
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4racndom)
        } else {
            return nil
        }
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
