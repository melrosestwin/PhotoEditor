//
//  BrandSlider.swift
//  PhotoEditor
//

import SwiftUI

struct BrandSlider: View {
    
    private let thumbRadius: CGFloat = 27.adaptive()
    
    @Binding var value: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            GeometryReader { reader in
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(.brandGray)
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(.lightYellow)
                        .mask(alignment: .leading) {
                            Rectangle()
                                .frame(width: reader.size.width * min(value, 1) - thumbRadius / 2)
                        }
                }
                .frame(height: 2.adaptive())
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(.black)
                        .frame(width: thumbRadius, height: thumbRadius)
                        .overlay {
                            Circle()
                                .stroke(LinearGradient.yellow, lineWidth: 2.adaptive())
                                .frame(width: 18.adaptive(), height: 18.adaptive())
                        }
                        .offset(x: reader.size.width * min(value, 1) - thumbRadius / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newValue = max(0, min(1, (value.location.x / reader.size.width)))
                                    self.value = newValue
                                }
                        )
                }
            }
            .frame(height: 2.adaptive())
            .padding(.horizontal, thumbRadius / 2)
            
            Spacer()
        }
        .frame(height: 28.adaptive())
    }
}
