//
//  Adaptation.swift
//  PhotoEditor
//

import Foundation
import UIKit

extension Int {
    
    func adaptive(_ scale: Double = 1.5) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if UIDevice.isIphone {
            if screenHeight > 800 {
                return CGFloat(self) * (screenHeight / 852)
            } else {
                return CGFloat(self) * (screenHeight / 736)
            }
        } else {
            let isPro = UIScreen.screenWidth / UIScreen.screenHeight > 0.72
            if isPro {
                return CGFloat(self) * scale * (screenHeight / 1194)
            } else {
                return CGFloat(self) * scale * (screenHeight / 1280)
            }
        }
    }
}
