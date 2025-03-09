//
//  BrushPath.swift
//  PhotoEditor
//

import SwiftUI

protocol CanvasPath {
    var points: [CGPoint] { get set }
    var lineWidth: CGFloat { get set }
    var path: Path { get }
}

final class BrushPath: CanvasPath {
    
    var tool: CanvasTool
    var points: [CGPoint]
    var lineWidth: CGFloat
    
    var path: Path {
        var path = Path()
        if let firstPoint = points.first {
            path.move(to: firstPoint)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        return path
    }
    
    init(tool: CanvasTool, points: [CGPoint], lineWidth: CGFloat) {
        self.tool = tool
        self.points = points
        self.lineWidth = lineWidth
    }
}

final class EraserPath: CanvasPath {
    
    var points: [CGPoint]
    var lineWidth: CGFloat
    
    var path: Path {
        var path = Path()
        if let firstPoint = points.first {
            path.move(to: firstPoint)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        return path
    }
    
    init(points: [CGPoint], lineWidth: CGFloat) {
        self.points = points
        self.lineWidth = lineWidth
    }
}
