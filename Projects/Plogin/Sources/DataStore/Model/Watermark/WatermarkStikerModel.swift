//
//  WatermarkStikerModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import Design

@Model
public final class WatermarkStikerModel {
    var image: Data?
    var alpha: CGFloat
    var position: CGPoint
    var rotation: CGFloat
    var scale: CGFloat
    var layer: Int
    
    var watermark: WatermarkModel?
    
    init(
        image: PImage,
        alpha: CGFloat,
        position: CGPoint,
        rotation: CGFloat,
        scale: CGFloat,
        layer: Int
    ) {
        self.image = image.pngData()
        self.alpha = alpha
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.layer = layer
    }
}
