//
//  RenderingCanvasView.swift
//  PhotoEditor
//

import SwiftUI

struct RenderingCanvasView: View {
    
    let paths: [BrushPath]
    
    var body: some View {
        Canvas { context, size in
            context.blendMode = .destinationAtop
            paths.forEach { path in
                context.stroke(path.path, with: .color(.black), style: .init(lineWidth: path.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
    }
}
