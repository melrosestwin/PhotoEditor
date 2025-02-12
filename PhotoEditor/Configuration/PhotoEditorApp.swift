//
//  PhotoEditorApp.swift
//  PhotoEditor
//

import SwiftUI

@main
struct PhotoEditorApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(isFirstLaunch: .constant(false))
        }
    }
}
