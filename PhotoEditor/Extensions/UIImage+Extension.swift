//
//  UIImage+Extension.swift
//  PhotoEditor
//

import UIKit

extension UIImage {
    func getCopy() -> UIImage? {
        if let pngData = self.pngData() {
            return UIImage(data: pngData)
        } else {
            return nil
        }
    }
    
    func cropped(to rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        // Convert points to pixels
        let scale = self.scale
        let pixelRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale
        )
        
        guard let croppedCGImage = cgImage.cropping(to: pixelRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: self.imageOrientation)
    }
}
