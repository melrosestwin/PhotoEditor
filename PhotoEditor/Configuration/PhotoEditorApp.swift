//
//  PhotoEditorApp.swift
//  PhotoEditor
//

import SwiftUI

@main
struct PhotoEditorApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isFirstLaunch {
                    OnboardingView(isFirstLaunch: $isFirstLaunch)
                } else {
                    MainView()
                }
            }
            .animation(.default, value: isFirstLaunch)
        }
    }
}
