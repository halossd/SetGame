//
//  CardView.swift
//  demo2
//
//  Created by cc on 2022/4/25.
//

import UIKit

class SetCardsContainerView: CardsContainerView
{

    override func makeCardViews(byAmount numberOfButtons: Int) -> [SetCardView] {
        return (0..<numberOfButtons).map { _ in SetCardView() }
    }
}
