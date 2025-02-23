//
//  NavigationContent.swift
//  PhotoEditor
//

import SwiftUI

struct NavigationContent: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let backButtonTitle: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 5.adaptive()) {
                            Image(systemName: "chevron.left")
                            Text(backButtonTitle)
                                .font(.poppins(17.adaptive()))
                        }
                        .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.poppins(17.adaptive(), weight: .bold))
                        .foregroundStyle(.white)
                }
            }
    }
}

extension View {
    public func navigationContent(title: String, backButtonTitle: String = "Return") -> some View {
        modifier(NavigationContent(title: title, backButtonTitle: backButtonTitle))
    }
}
