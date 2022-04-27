//
//  ViewController.swift
//  demo2
//
//  Created by cc on 2022/4/15.
//

import UIKit

@IBDesignable
class SetViewController: UIViewController {
    
    var game = SetDeck()

    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var setView: SetCardsContainerView!
    var cards = [Card]()
    var showedCards = [Card]()
    var selectedCards = [Card]()
    var selectedCardViews = [UIButton]()
    
    private var setLabelCount = 0 { didSet { setLabel.text = "Point:\(setLabelCount)" } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView.backgroundColor = .yellow

        setView.addCards(byAmount: 12)
        
        for _ in 1...81 {
            let card = game.draw()!
            cards.append(card)
        }

        for (i, button) in setView.buttons.enumerated() {
            button.card = cards.remove(at: i)
        }

    }
    
    private func assignTargetAction() {
        for button in setView.buttons {
            button.addGestureRecognizer(UITapGestureRecognizer(target: button, action: #touchCard(_:)))
        }
    }
    
    @objc func touchCard(_ sender: SetCardView) {

    }
    
    @IBAction func dealCards(_ sender: UIButton) {

    }
    
    private var isHintMatching = false
    
    @IBAction func hint(_ sender: Any) {

    }
    
    func updateViewForMatchedCards(_ cards: [Int]) {

    }
}

