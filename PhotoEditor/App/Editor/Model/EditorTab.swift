//
//  EditorTool.swift
//  PhotoEditor
//

import SwiftUI

enum EditorTab: Int, CaseIterable {
    case background
    case insert
    case outfit
    case size
    
    var title: String {
        switch self {
        case .background:
            return "Remove background"
        case .insert:
            return "Insert object"
        case .outfit:
            return "Change outfit"
        case .size:
            return "Card size"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .background: .backgroundTool
        case .insert: .insertTool
        case .outfit: .outfitTool
        case .size: .sizeTool
        }
    }
    
    var generatorPlaceholder: String {
        switch self {
        case .background: "Day, football stadium"
        case .insert: "Hand holding a soccer ball"
        case .outfit: "Football uniform, black and yellow"
        case .size: ""
        }
    }
}
