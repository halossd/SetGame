//
//  ObjectView.swift
//  demo2
//
//  Created by cc on 2022/4/25.
//

import UIKit

class SetCardView: UIView {
    
    private var shape: Card.Shape?
    private var color: Card.ShapeColor?
    private var shading: Card.Shading?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame:CGRect, shape: Card.Shape, color: Card.ShapeColor, shading: Card.Shading) {
        self.init(frame: frame)
        self.shape = shape
        self.color = color
        self.shading = shading
        backgroundColor = .clear
    }
    
    private var path: UIBezierPath {
        if let shape = shape {
            switch shape {
            case .triangle:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.midX, y: 0))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                path.close()
                return path
            case .square:
                return UIBezierPath(rect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height))
            case .round:
                return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            }
        }
        return UIBezierPath()
    }

    override func draw(_ rect: CGRect) {
        let shape = path
        path.addClip()
        
        var objectColor = UIColor.blue
        if let color = color {
            switch color {
            case .red:
                objectColor = .red
            case .blue:
                objectColor = .blue
            case .green:
                objectColor = .green
            }
        }
        
        if let shading = shading {
            switch shading {
            case .solid:
                objectColor.setFill()
                shape.fill()
            case .striped:
                objectColor.setStroke()
                for x in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.stroke()
                }
                for y in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: y, y: bounds.width))
                    path.addLine(to: CGPoint(x: bounds.width, y: y))
                    path.stroke()
                }
            case .open:
                objectColor.setStroke()
                shape.lineWidth = 5
                shape.stroke()
            }
        }
    }
}
