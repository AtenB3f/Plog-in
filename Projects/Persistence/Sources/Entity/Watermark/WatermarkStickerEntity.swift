//
//  WatermarkStickerEntity.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class WatermarkStickerEntity {
    var imageData: Data
    var alpha: CGFloat
    var position: CGPoint
    var rotation: CGFloat
    var scale: CGFloat
    var layer: Int
    
    var watermark: WatermarkEntity?
    
    init(
        image: Data,
        alpha: CGFloat,
        position: CGPoint,
        rotation: CGFloat,
        scale: CGFloat,
        layer: Int
    ) {
        self.imageData = image
        self.alpha = alpha
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.layer = layer
    }
}
