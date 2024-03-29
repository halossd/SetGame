//
//  ObjectView.swift
//  demo2
//
//  Created by cc on 2022/4/25.
//

import UIKit

class SetCardView: UIView {
    
    var card: Card? { didSet { setNeedsDisplay() } }
    
    private var nubmer: Card.Number? {
        return card?.number
    }
    private var shape: Card.Shape? {
        return card?.shape
    }
    private var color: Card.ShapeColor? {
        return card?.color
    }
    private var shading: Card.Shading? {
        return card?.shading
    }
    
    var isSelected = false {
        didSet {
            if isSelected {
                layer.borderWidth = 3
                layer.borderColor = UIColor.blue.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    var isActive = false
    
    var isFaceUp = false {
        didSet {
            if isFaceUp {
                backgroundColor = .white
            }
            setNeedsDisplay()
        }
    }
    
    private var numberOfSymbols: Int {
        if let nubmer = nubmer {
            return nubmer.rawValue
        }
        return 0
    }
        
    private var path: UIBezierPath?
    
    private var drawableRect: CGRect {
        let drawableWidth = frame.width * 0.8
        let drawableHeight = frame.height * 0.95
        return CGRect(x: frame.width * 0.1,
                      y: frame.height * 0.025,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    private var shapeHorizontalMargin: CGFloat {
        return drawableRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
        return (drawableRect.height - shapeHeight) / 2 + drawableRect.origin.y
    }
    
    private var shapeWidth: CGFloat {
        return (drawableRect.width - 2 * shapeHorizontalMargin) / 3
    }
    
    private var shapeHeight: CGFloat {
        return shapeWidth
    }
    
    private var drawableCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height * 0.15
        layer.masksToBounds = true
        
        if !isFaceUp {
            backgroundColor = .gray
            return
        }
        
        guard card != nil else {
            return
        }
        var objectColor = UIColor.blue
        if let color = color {
            switch color {
            case .red:
                objectColor = UIColor(red: 255/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1)
            case .blue:
                objectColor = UIColor(red: 86/255.0, green: 86/255.0, blue: 249/255.0, alpha: 1)
            case .green:
                objectColor = UIColor(red: 37/255.0, green: 222/255.0, blue: 104/255.0, alpha: 1)
            }
        }
        
        if let shape = shape {
            switch shape {
            case .triangle:
                drawTriangle(byAmount: numberOfSymbols)
            case .square:
                drawSquare(byAmount: numberOfSymbols)
            case .round:
                drawRound(byAmount: numberOfSymbols)
            }
        }
        
        path!.addClip()
        path?.lineCapStyle = .round
        
        if let shading = shading {
            switch shading {
            case .solid:
                objectColor.setFill()
                path!.fill()
            case .striped:
                path!.lineWidth = 3
                objectColor.setStroke()
                path!.stroke()
                
                let stripedPath = UIBezierPath()
                stripedPath.lineWidth = 0.003 * frame.width
                for x in stride(from: 0, to: frame.width, by: frame.width * 0.04) {
                    stripedPath.move(to: CGPoint(x: x, y: 0))
                    stripedPath.addLine(to: CGPoint(x: 0, y: x))
                }
                for y in stride(from: 0, to: frame.width, by: frame.width * 0.04) {
                    stripedPath.move(to: CGPoint(x: y, y: frame.width))
                    stripedPath.addLine(to: CGPoint(x: frame.width, y: y))
                }
                objectColor.setStroke()
                stripedPath.stroke()
                
            case .open:
                objectColor.setStroke()
                path!.lineWidth = 3
                path!.stroke()
            }
        }
    }
    
    private func drawSquare(byAmount amount: Int) {
        let path = UIBezierPath()
        
        let allSquareWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        
        let beginX = (frame.width - allSquareWidth) / 2
        let currentShapeY = shapeVerticalMargin
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + CGFloat(i)*shapeHorizontalMargin
            
            path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        }
        self.path = path
        
    }
    
    private func drawTriangle(byAmount amount: Int) {
        let path = UIBezierPath()
        
        let allSquareWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        
        let beginX = (frame.width - allSquareWidth) / 2
        let currentShapeY = shapeVerticalMargin
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + CGFloat(i)*shapeHorizontalMargin
            
            path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: currentShapeY))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: currentShapeY))
        }
        self.path = path
    }
    
    private func drawRound(byAmount amount: Int) {
        let allSquareWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.width - allSquareWidth) / 2
        let currentShapeY = shapeVerticalMargin
        path = UIBezierPath()
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + CGFloat(i)*shapeHorizontalMargin
            
            path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                          y: currentShapeY,
                                                          width: shapeWidth,
                                                          height: shapeHeight
                                                         ),
                                      cornerRadius: shapeWidth))
            
            
        }
    }
}
