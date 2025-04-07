//
//  Data+Extension.swift
//  PhotoEditor
//

import UIKit
import CoreData

public extension StoredImage {
    var uiImage: UIImage? {
        if let data {
            return UIImage(data: data)
        }
        return nil
    }
}

public extension Project {
    
    var originalImage: UIImage? {
        get {
            if let data = self.originalImageData {
                return UIImage(data: data)
            }
            return nil
        }
        set {
            self.originalImageData = newValue?.pngData()
        }
    }
    
    var sportKind: SportKind {
        get {
            return SportKind(rawValue: sportKindId) ?? .soccer
        }
        set {
            self.sportKindId = newValue.rawValue
        }
    }
}
