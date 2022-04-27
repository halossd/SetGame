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
    
    var buttons = [SetCardView]()
    
    var grid = SetGrid(layout: SetGrid.Layout.aspectRatio(2.5))
    
    var gridRect: CGRect {
      get {
        return CGRect(x: bounds.width * 0.025,
                      y: bounds.height * 0.025,
                      width: bounds.width * 0.95,
                      height: bounds.height * 0.95)
      }
    }

    /// Instantiates a new array of buttons with the specified count of elements.
    func makeCardViews(byAmount numberOfButtons: Int) -> [SetCardView] { return [] }
    
    func addCards(byAmount amount: Int = 3) {
        let cardViews = makeCardViews(byAmount: amount)
        for cardView in cardViews {
            cardView.backgroundColor = .white
            addSubview(cardView)
            buttons.append(cardView)
        }
        
        grid.cellCount += amount
        grid.frame = gridRect
        
        respositionViews()
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
}
