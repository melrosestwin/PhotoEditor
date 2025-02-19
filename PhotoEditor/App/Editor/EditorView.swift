//
//  EditorView.swift
//  PhotoEditor
//

import SwiftUI

struct EditorView: View {
    
    @State var sliderValue: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.editorPlaceholder)
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            toolsBar
        }
        .ignoresSafeArea()
    }
    
    var toolsBar: some View {
        VStack {
            BrandSlider(value: $sliderValue)
                .padding(.horizontal, 36.adaptive())
            
            Spacer()
            
            HStack(spacing: 12.adaptive()) {
                Image(.brushTipIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28.adaptive())
                
                Text("Brush over the image to select the area to insert the object.")
                    .font(.poppins(10.adaptive()))
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding(.top, 16.adaptive())
        .padding(.bottom, 20.adaptive())
        .background {
            Image(.toolsBackground)
                .resizable()
        }
    }
}

#Preview {
    EditorView()
}
