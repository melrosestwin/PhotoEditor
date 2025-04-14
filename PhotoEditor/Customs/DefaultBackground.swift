//
//  NavigationContent.swift
//  PhotoEditor
//

import SwiftUI

public enum DefaultBackground: Int {
    case primary
    case secondary
    
    var image: ImageResource {
        switch self {
        case .primary: .primaryBackground
        case .secondary: .secondaryBackground
        }
    }
}

struct DefaultBackgroundViewModifier: ViewModifier {
    
    let background: DefaultBackground
    
    func body(content: Content) -> some View {
        content
            .background(alignment: .center) {
                Image(background.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .ignoresSafeArea()
            }
    }
}

extension View {
    public func setDefaultBackground(_ background: DefaultBackground) -> some View {
        modifier(DefaultBackgroundViewModifier(background: background))
    }
}
