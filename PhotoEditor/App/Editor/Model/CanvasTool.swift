//
//  CanvasTool.swift
//  PhotoEditor
//

import SwiftUI

enum CanvasTool: Int, CaseIterable {
    case brush
    case eraser
    
    var icon: ImageResource {
        switch self {
        case .brush: .brushIcon
        case .eraser: .eraserIcon
        }
    }
    
    var color: Color {
        switch self {
        case .brush: .brushPink
        case .eraser: .clear
        }
    }
}
