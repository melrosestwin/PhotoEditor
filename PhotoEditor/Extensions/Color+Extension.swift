//
//  Color+Extension.swift
//  PhotoEditor
//

import SwiftUI

extension Color {
    init(hex: UInt) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}


