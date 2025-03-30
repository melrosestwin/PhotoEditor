//
//  BrushPath.swift
//  PhotoEditor
//

import SwiftUI

final class BrushPath {
    
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
