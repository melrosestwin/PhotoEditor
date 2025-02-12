//
//  DynamicHeightView.swift
//  Pillinko
//

import SwiftUI

struct DynamicHeightView<Content: View>: View {
    
    let content: (CGFloat) -> Content
    @State private var height: CGFloat = 0
    
    var body: some View {
        VStack {
            content(height)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                height = geometry.size.height
                            }
                            .onChange(of: geometry.size.height) { newHeight in
                                height = newHeight
                            }
                    }
                )
        }
    }
}
