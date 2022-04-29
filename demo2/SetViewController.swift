//
//  ViewController.swift
//  demo2
//
//  Created by cc on 2022/4/15.
//

import UIKit

@IBDesignable
class SetViewController: UIViewController, SetGameDelegate
{
    
    var game = SetGame()

    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var setView: SetCardsContainerView!
    
    var cards = [Card]()
    var showedCards = [Card]()
    var selectedCards = [Card]()
    var selectedCardViews = [UIButton]()
    
    private var score = 0 { didSet { setLabel.text = "Point: \(score)" } }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setView.prepareForRotation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.delegate = self
        
        setView.addCards(byAmount: 12)
        
        game.dealCards(forAmount: 12)

        disPlayCards()
        
        assignTargetAction()
    }
    
    func disPlayCards() {
        for (index, button) in setView.buttons.enumerated() {
            guard game.tableCards.indices.contains(index) else { continue }
            
            let currentCard = game.tableCards[index]
            button.card = currentCard
        }
    }
    
    func assignTargetAction() {
        for button in setView.buttons {
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(_:))))
        }
    }
    
    private var isAnimating = false
    
    @objc func touchCard(_ recongnizer: UITapGestureRecognizer) {
        if isAnimating && isHintMatching { return }
        switch recongnizer.state {
        case .ended:
            if let cardButton = recongnizer.view as? SetCardView,
                let index = setView.buttons.firstIndex(of: cardButton) {
                cardButton.isSelected = !cardButton.isSelected
                game.selectCard(at: index)
                disPlayCards()
                score = game.score
            }
        default: break
        }
        
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        guard game.tableCards.count < 24, game.deck.count >= 3 else {
            return
        }

        setView.addCards()
        game.dealCards()
        disPlayCards()
        assignTargetAction()
    }
    
    func selectedCardsDidMatch(_ cards: [Card]) {
        isAnimating = true
        if game.deck.count == 0 {
            let selectedButtons = cards.map { card -> SetCardView in
                let cardIndex = self.game.tableCards.firstIndex(of: card)!
                return self.setView.buttons[cardIndex]
            }
            selectedButtons.forEach {
                $0.removeFromSuperview()
                setView.buttons.remove(at: setView.buttons.firstIndex(of: $0)!)
            }
            setView.removeInactiveCard()
            self.isAnimating = false
        } else {
            cards.forEach { card in
                if let i = game.tableCards.firstIndex(of: card) {
                    UIView.transition(
                        with: setView.buttons[i],
                        duration: 0.6,
                        options: [.transitionFlipFromLeft]) {
                            self.setView.buttons[i].isSelected = false
                        } completion: { finished in
                            self.isAnimating = false
                        }
                }

            }

        }
    }
    
    func selectedCardsDissMatch(_ cards: [Card]) {
        cards.forEach {
            if let index = game.tableCards.firstIndex(of: $0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0) {
                    self.setView.buttons[index].isSelected = false
                    
                }
                
            }
        }
    }
    
    private var isHintMatching = false
    
    @IBAction func touchNewGame() {
        game.rest()
        setView.removeAllSubViews()
        setView.clearCardContainer()
        score = game.score
        
        setView.addCards(byAmount: 12)
        game.dealCards(forAmount: 12)
        disPlayCards()
        assignTargetAction()

    }
    
    @IBAction func hint(_ sender: Any) {
        if !isHintMatching && !isAnimating {
            game.hint(on: game.tableCards)
            if !game.hintCards.isEmpty {
                isHintMatching = true
                game.hintCards.forEach { i in
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0) {
                            self.setView.buttons[i].isSelected = true
                        } completion: { finished in
                            UIView.animate(
                                withDuration: 0.3,
                                delay: 0) {
                                    self.setView.buttons[i].isSelected = false
                                } completion: { stop in
                                    self.isHintMatching = false
                                }
                        }
                }
            }
        }
    }
}

