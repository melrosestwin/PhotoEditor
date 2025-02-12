//
//  Font+Extension.swift
//  PhotoEditor
//
//  Created by Николай Гарчу on 12.02.2025.
//


import SwiftUI

typealias FontName = String
extension FontName {
    static let poppins: String = "Poppins"
    static let mazzard: String = "MazzardH-Bold"
}

extension Font {
    
    static func poppins(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom(.poppins, size: size).weight(weight)
    }
    
    static func mazzard(_ size: CGFloat) -> Font {
        Font.custom(.mazzard, size: size)
    }
}
