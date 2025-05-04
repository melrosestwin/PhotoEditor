//
//  RenderingCanvasView.swift
//  PhotoEditor
//

import SwiftUI

struct RenderingCanvasView: View {
    
    let paths: [BrushPath]
    
    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.black))
            paths.forEach { path in
                context.stroke(path.path, with: .color(.white), style: .init(lineWidth: path.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
    }
}
