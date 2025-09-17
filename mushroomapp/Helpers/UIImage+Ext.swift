//
//  UIImage+Ext.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import UIKit

extension UIImage {
    /// Resize image to target size
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    /// Resize image by a scale factor (e.g., 0.5 = reduce size by 50%)
    func resized(by scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return resized(to: newSize)
    }

    /// Resize image maintaining aspect ratio to fit within a bounding box
    func resizedToFit(maxSize: CGSize) -> UIImage? {
        let aspectWidth = maxSize.width / size.width
        let aspectHeight = maxSize.height / size.height
        let scale = min(aspectWidth, aspectHeight)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return resized(to: newSize)
    }
}

