//
//  CardContainerView.swift
//  demo2
//
//  Created by cc on 2022/4/27.
//

import UIKit

@IBDesignable
class CardsContainerView: UIView
{
    @IBInspectable var nubmerOfCardsForDisplay: Int = 0
    
    var dealingFromFrame: CGRect = .zero
    
    var discardToFrame: CGRect = .zero
    
    var buttons = [SetCardView]()
    
    var grid = SetGrid(layout: SetGrid.Layout.aspectRatio(2))
    
    var gridRect: CGRect {
      get {
        return CGRect(x: bounds.width * 0.025,
                      y: bounds.height * 0.025,
                      width: bounds.width * 0.95,
                      height: bounds.height * 0.95)
      }
    }

    func prepareForRotation() {
        for button in buttons {
            button.transform = .identity
            button.setNeedsDisplay()
        }
    }
    
    /// Instantiates a new array of buttons with the specified count of elements.
    func makeCardViews(byAmount numberOfButtons: Int) -> [SetCardView] { return [] }
    
    func addCards(byAmount amount: Int = 3, animated: Bool = false) {
        let cardViews = makeCardViews(byAmount: amount)
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            addSubview(cardView)
            buttons.append(cardView)
        }
        
        grid.cellCount += amount
        grid.frame = gridRect
        
        if animated {
            dealCardsWithAnimation()
        }
    }
    
    func dealCardsWithAnimation() {
        
    }
    
    func respositionViews() {
        grid.frame = gridRect
        
        for (i, button) in buttons.enumerated() {
            if let frame = grid[i] {
                button.frame = frame
            }
        }
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if grid.frame != gridRect {
            respositionViews()
        }
    }
    
    func removeInactiveCard() {
        grid.cellCount = buttons.count
        respositionViews()
    }
    
    func clearCardContainer() {
        buttons.forEach {
            $0.removeFromSuperview()
        }
        buttons = []
        grid.cellCount = 0
        
        setNeedsLayout()
    }

}

extension UIView {
    func removeAllSubViews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
