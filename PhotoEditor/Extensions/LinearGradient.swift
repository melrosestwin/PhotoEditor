//
//  LinearGradient.swift
//  PhotoEditor
//

import SwiftUI

extension LinearGradient {
    
    static let brandBackground = LinearGradient(
        colors: [
            Color(hex: 0x3C0946),
            Color(hex: 0x491D7F)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let itemSelection = LinearGradient(
        colors: [
            Color(hex: 0xF46188),
            Color(hex: 0xFF00BF)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    init(from color: Color) {
        self.init(colors: [color], startPoint: .top, endPoint: .bottom)
    }
}
