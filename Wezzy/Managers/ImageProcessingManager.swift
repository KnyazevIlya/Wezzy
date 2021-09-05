//
//  ImageProcessingManager.swift
//  Wezzy
//
//  Created by admin on 05.09.2021.
//

import UIKit
import CoreGraphics

class ImageProcessingManager {
    
    static let shared = ImageProcessingManager()
    
    struct Pixel {
        var r, g, b: Int
    }
    
    private init() {}
    
    func getAverageColor(forCGImage image: CGImage) -> Pixel {
        var rChanel = 0
        var gChanel = 0
        var bChanel = 0
        var pixelsProcessed = 0
        
        guard
            let provider = image.dataProvider,
            let providedData = provider.data,
            let data = CFDataGetBytePtr(providedData) else {
                return Pixel(r: 0, g: 0, b: 0)
            }
        
        let numberOfComponents = 4
        
        for indexV in stride(from: 0, to: image.height, by: 2) {
            for indexH in stride(from: 1, to: image.width, by: 2) {
                let pixelData = ((Int(image.width) * indexH) + indexV) * numberOfComponents
                rChanel += Int(data[pixelData])
                gChanel += Int(data[pixelData + 1])
                bChanel += Int(data[pixelData + 2])
                pixelsProcessed += 1
            }
        }
        
        let averageColor = Pixel(
            r: Int(rChanel / pixelsProcessed),
            g: Int(gChanel / pixelsProcessed),
            b: Int(bChanel / pixelsProcessed)
        )
        
        return averageColor
    }
}
