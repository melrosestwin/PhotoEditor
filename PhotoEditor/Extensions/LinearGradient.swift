//
//  LinearGradient.swift
//  PhotoEditor
//

import SwiftUI

extension LinearGradient {
    
    static let yellow = LinearGradient(
        colors: [
            .lightYellow,
            .darkYellow
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    init(from color: Color) {
        self.init(colors: [color], startPoint: .top, endPoint: .bottom)
    }
}
