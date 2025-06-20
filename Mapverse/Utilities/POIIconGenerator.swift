//
//  POIIconGenerator.swift
//  Mapverse
//
//  Created by Dave Paiva on 20/06/25.
//

import Foundation
import CoreGraphics
import UIKit

/// Generate a custom icon image for a POI
  /// - Parameters:
  ///   - emoji: The emoji character
  ///   - size: Icon size (default 32x32)
  ///   - backgroundColor: Background color
  ///   - borderColor: Border color
  ///   - borderWidth: Border width
  /// - Returns: UIImage with the custom icon

struct POIIconGenerator {
    static func createIcon(
        emoji: String,
        size: CGFloat = 32,
        backgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9),
        borderColor: UIColor = .systemBlue,
        borderWidth: CGFloat = 1.5
    ) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            let cgContext = context.cgContext
            
            cgContext.setFillColor(backgroundColor.cgColor)
            cgContext.fillEllipse(in: rect)
            
            cgContext.setStrokeColor(borderColor.cgColor)
            cgContext.setLineWidth(borderWidth)
            cgContext.strokeEllipse(in: rect)
            
            let fontSize = size * 0.6
            let font = UIFont.systemFont(ofSize: fontSize)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            let emojiSize = emoji.size(withAttributes: attributes)
            let emojiRect = CGRect(
                x: (size - emojiSize.width) / 2,
                y: (size - emojiSize.height) / 2,
                width: emojiSize.width,
                height: emojiSize.height
            )
            emoji.draw(in: emojiRect, withAttributes: attributes)
        }
        
    }
}
