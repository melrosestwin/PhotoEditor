//
//  NavigationContent.swift
//  PhotoEditor
//

import SwiftUI

struct NavigationContent<TrailingContent: View>: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let backButtonTitle: String
    let trailingContent: TrailingContent
    
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
                ToolbarItem(placement: .topBarTrailing) {
                    trailingContent
                }
            }
    }
}

extension View {
    public func navigationContent<TrailingContent: View>(
        title: String,
        backButtonTitle: String = "Return",
        @ViewBuilder trailing: @escaping () -> TrailingContent = { EmptyView() }
    ) -> some View {
        modifier(NavigationContent(title: title, backButtonTitle: backButtonTitle, trailingContent: trailing()))
    }
}
