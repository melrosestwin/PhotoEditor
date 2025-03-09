//
//  BrandSlider.swift
//  PhotoEditor
//

import SwiftUI

struct BrandSlider: View {
    
    private let thumbDiameter: CGFloat = 27.adaptive()
    @Binding var value: Double
    
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
                                .frame(width: (reader.size.width - thumbDiameter / 2) * min(value, 1))
                        }
                }
                .frame(height: 2.adaptive())
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(.black)
                        .frame(width: thumbDiameter, height: thumbDiameter)
                        .overlay {
                            Circle()
                                .stroke(LinearGradient.yellow, lineWidth: 2.adaptive())
                                .frame(width: 18.adaptive(), height: 18.adaptive())
                        }
                        .offset(x: (reader.size.width - thumbDiameter) * min(value, 1))
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
            
            Spacer()
        }
        .frame(height: 28.adaptive())
    }
}
