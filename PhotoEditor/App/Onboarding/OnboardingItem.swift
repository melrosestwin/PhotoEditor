//
//  OnboardingItem.swift
//  PhotoEditor
//

import SwiftUI

enum OnboardingItem: Int, CaseIterable {
    case create
    case edit
    case choice
    
    var banner: ImageResource {
        switch self {
        case .create: .onboardingCreate
        case .edit: .onboardingEdit
        case .choice: .onboardingChoice
        }
    }
    
    var colorfultText: String {
        switch self {
        case .create: "Create"
        case .edit: "Edit"
        case .choice: "Your choice"
        }
    }
    
    var simpleText: String {
        switch self {
        case .create: " a unique sports photo card with AI! Choose a sport, upload a photo – and start creating!"
        case .edit: " the background, change clothes and add details. AI will help you create the perfect style!"
        case .choice: " Football, Boxing, or Crisket - the latest sports and creativity with AI!"
        }
    }
}
