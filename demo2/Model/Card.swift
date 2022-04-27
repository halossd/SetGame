//
//  Card.swift
//  demo2
//
//  Created by cc on 2022/4/16.
//

import Foundation

struct Card: CustomStringConvertible, Equatable
{
    var description: String { return "\(number) \(shape) \(color) \(shading)" }

    var number: Number = .one
    var color: ShapeColor = .red
    var shape: Shape = .triangle
    var shading: Shading = .open
    
    enum Shape: String {
        case triangle
        case square
        case round
        
        static var all = [Shape.triangle, .square, .round]
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        
        static var all = [Number.one, .two, .three]
    }
    
    enum Shading: String {
        case solid
        case striped
        case open
        
        static var all = [Shading.solid, .striped, .open]
    }
    
    enum ShapeColor: String {
        case red
        case blue
        case green
        
        static var all = [ShapeColor.red, .blue, .green]
    }
}

