//
//  NavigationContent.swift
//  PhotoEditor
//

import SwiftUI

struct DefaultBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(alignment: .center) {
                Image(.mainBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .ignoresSafeArea()
            }
    }
}

extension View {
    public func setDefaultBackground() -> some View {
        modifier(DefaultBackground())
    }
}
