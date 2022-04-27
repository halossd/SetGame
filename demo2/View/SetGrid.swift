//
//  SetFlow.swift
//  demo2
//
//  Created by cc on 2022/4/26.
//

import Foundation
import UIKit

struct SetGrid
{
    enum Layout {
        case fixedCellSize(CGSize)
        case dimensions(rowCount: Int, colCount: Int)
        case aspectRatio(CGFloat)
    }
    
    var layout: Layout { didSet { recalculate() } }
    
    var frame: CGRect { didSet { recalculate() } }
    
    init(layout: Layout, frame: CGRect = .zero) {
        self.layout = layout
        self.frame = frame
        recalculate()
    }
    
    subscript(row: Int, column: Int) -> CGRect? {
        return self[row * dimensions.colCount + column]
    }
    
    subscript(index: Int) -> CGRect? {
        return index < cellFrames.count ? cellFrames[index] : nil
    }
    
    var cellCount: Int {
        get {
            switch layout {
            case .aspectRatio:
                return cellCountForAspectRatioLayout
            case .dimensions, .fixedCellSize:
                return calculatedDimensions.rowCount * calculatedDimensions.colCount
            }
        }
        set { cellCountForAspectRatioLayout = newValue }
    }
    
    var cellSize: CGSize {
        get { return cellFrames.first?.size ?? .zero }
        set { layout = .fixedCellSize(newValue) }
    }
    
    var dimensions: (rowCount: Int, colCount: Int) {
        get { return calculatedDimensions }
        set { layout = .dimensions(rowCount: newValue.rowCount, colCount: newValue.colCount) }
    }
    
    var aspectRatio: CGFloat {
        get {
            switch layout {
            case .fixedCellSize(let cellSize):
                return cellSize.height > 0 ? cellSize.width / cellSize.height : 0
            case .dimensions(let rowCount, let colCount):
                if rowCount > 0 && colCount > 0 && frame.width > 0 {
                    return (frame.width / CGFloat(colCount)) / (frame.height / CGFloat(colCount))
                } else {
                    return 0.0
                }
            case .aspectRatio(let aspectRatio):
                return aspectRatio
            }
        }
        set { layout = .aspectRatio(newValue) }
    }
    
    private var cellFrames = [CGRect]()
    private var cellCountForAspectRatioLayout = 0 { didSet { recalculate() } }
    private var calculatedDimensions: (rowCount: Int, colCount: Int) = (0, 0)
    
    private mutating func recalculate() {
        switch layout {
        case .fixedCellSize(let cellSize):
            if cellSize.width > 0 && cellSize.height > 0 {
                calculatedDimensions.rowCount = Int(frame.height / cellSize.height)
                calculatedDimensions.colCount = Int(frame.width / cellSize.width)
            } else {
                assert(false, "Grid: for fixedCellSize layout, cellSize height and width must be positive numbers")
                calculatedDimensions = (0, 0)
                cellFrames.removeAll()
            }
        case .dimensions(let rowCount, let colCount):
            if rowCount > 0 && colCount > 0 {
                calculatedDimensions.rowCount = rowCount
                calculatedDimensions.colCount = colCount
                let cellSize = CGSize(width: frame.width / CGFloat(rowCount), height: frame.height / CGFloat(colCount))
                updateCellFrame(to: cellSize)
            } else {
                assert(false, "Grid: for dimensions layout, rowCount and columnCount must be positive numbers")
                calculatedDimensions = (0, 0)
                cellFrames.removeAll()
            }
        case .aspectRatio:
            assert(aspectRatio > 0, "Grid: for aspectRatio layout, aspectRatio must be a positive number")
            let cellSize = largestCellSizeThatFitsAspectRatio()
            if cellSize.area > 0 {
                calculatedDimensions.colCount = Int(frame.width / cellSize.width)
                calculatedDimensions.rowCount = (cellCount + calculatedDimensions.colCount - 1) / calculatedDimensions.colCount
            } else {
                calculatedDimensions = (0,0)
            }
            updateCellFrame(to: cellSize)
            break
        }
    }
    
    private mutating func updateCellFrame(to cellSize: CGSize) {
        cellFrames.removeAll()
        
        let boundingSize = CGSize(
            width: CGFloat(dimensions.colCount) * cellSize.width,
            height: CGFloat(dimensions.rowCount) * cellSize.height
        )
        let offset = (
            dx: (frame.width - boundingSize.width) / 2,
            dy: (frame.height - boundingSize.height) / 2
        )
        var origin = frame.origin
        origin.x += offset.dx
        origin.y += offset.dy
        
        if cellCount > 0 {
            for _ in 0..<cellCount {
                cellFrames.append(CGRect(origin: origin, size: cellSize))
                origin.x += cellSize.width
                if round(origin.x) > round(frame.maxX - cellSize.width) {
                    origin.x = frame.origin.x + offset.dx
                    origin.y += cellSize.height
                }
            }
        }
        
    }
    
    private func largestCellSizeThatFitsAspectRatio() -> CGSize {
        var largetSoFar = CGSize.zero
        if cellCount > 0 && aspectRatio > 0 {
            for rowCount in 1...cellCount {
                largetSoFar = cellSizeAssuming(rowCount: rowCount, minimumAllowedSize: largetSoFar)
            }
            for colCount in 1...cellCount {
                largetSoFar = cellSizeAssuming(colCount: colCount, minimumAllowedSize: largetSoFar)
            }
        }
        return largetSoFar
    }
    
    private func cellSizeAssuming(rowCount: Int? = nil, colCount: Int? = nil, minimumAllowedSize: CGSize = .zero) -> CGSize {
        var size = CGSize.zero
        if let colCount = colCount {
            size.width = frame.width / CGFloat(colCount)
            size.height = size.width / aspectRatio
        } else if let rowCount = rowCount {
            size.height = frame.height / CGFloat(rowCount)
            size.width = size.height * aspectRatio
        }
        if size.area > minimumAllowedSize.area {
            if Int(frame.width / size.width) * Int(frame.height / size.height) >= cellCount {
                return size
            }
        }
        return minimumAllowedSize
    }
}

private extension CGSize {
    var area: CGFloat {
        return width * height
    }
}
