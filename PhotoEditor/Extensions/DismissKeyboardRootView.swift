//
//  DismissKeyboardRootView.swift
//  Pillinko
//


import SwiftUI

struct DismissKeyboardRootView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardRootView())
    }
}

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
