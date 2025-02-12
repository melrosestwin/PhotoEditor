//
//  YellowButton.swift
//  PhotoEditor
//

import SwiftUI

struct YellowButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.mazzard(24.adaptive()))
                .foregroundStyle(.buttonTitle)
                .frame(maxWidth: .infinity)
                .frame(height: 60.adaptive())
                .background {
                    LinearGradient(
                        colors: [.lightYellow, .darkYellow],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .shadow(color: .orangeShadow, radius: 12, x: 0, y: 0)
                }
                .clipShape(.rect(cornerRadius: 15.adaptive()))
        }
    }
}
