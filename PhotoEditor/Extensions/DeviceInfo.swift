//
//  DeviceInfo.swift
//  PhotoEditor
//

import UIKit

extension UIDevice {
    static let isIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    static let isBigIphone: Bool = UIScreen.main.bounds.height > 680
}
