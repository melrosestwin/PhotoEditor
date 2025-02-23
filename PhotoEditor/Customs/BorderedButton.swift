//
//  BorderedButton.swift
//  PhotoEditor
//

import SwiftUI

struct BorderedButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.mazzard(24.adaptive()))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60.adaptive())
                .contentShape(.rect)
                .background {
                    RoundedRectangle(cornerRadius: 15.adaptive(), style: .continuous)
                        .inset(by: 2.adaptive())
                        .stroke(LinearGradient.yellow, lineWidth: 4.adaptive())
                        .shadow(color: .orangeShadow, radius: 12, x: 0, y: 0)
                }
                .clipShape(.rect(cornerRadius: 15.adaptive()))
        }
    }
}
