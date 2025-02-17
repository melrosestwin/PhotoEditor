//
//  TutorialTip.swift
//  PhotoEditor
//

import SwiftUI

enum TutorialTip: Int, CaseIterable {
    case welcome
    case sections
    case tools
    case selection
    case generation
    case addition
    case background
    case ready
    
    
    
    var banner: ImageResource {
        switch self {
        case .welcome: .tipBanner1
        case .sections: .tipBanner2
        case .tools: .tipBanner3
        case .selection: .tipBanner4
        case .generation: .tipBanner5
        case .addition: .tipBanner6
        case .background: .tipBanner7
        case .ready: .tipBanner8
        }
    }
    
    var colorfultText: String {
        switch self {
        case .welcome: "Welcome "
        case .sections: "Sections: "
        case .tools: "Tools: "
        case .selection: "Selection: "
        case .generation: "Generation: "
        case .addition: "Addition: "
        case .background: "Background: "
        case .ready: "Ready "
        }
    }
    
    var simpleText: String {
        switch self {
        case .welcome: "to the AI ​​Sports Photo Card Maker tutorial! Let me introduce you to the tools."
        case .sections: "The editor has 4 sections: changing clothes, removing background, adding objects, changing size."
        case .tools: "The generation includes 3 tools: brush size, prompt input field and arrows for navigating changes."
        case .selection: "Try to carefully select with a brush the area you want to change for a better result."
        case .generation: "After selecting enter prompt and click on the generate button, for example sports."
        case .addition: "Select the area, describe it and click \"Generate\" to insert a new object into this area of ​​the photo card."
        case .background: "The background is automatically selected and replaced with a color, pattern or generation."
        case .ready: "to create unique photo cards? Click \"Start\" and get started!"
        }
    }
    
    static let editorTips: [TutorialTip] = [
        .welcome,
        .sections,
        .tools,
        .selection,
        .generation,
        .addition,
        .background,
        .ready,
    ]
}
