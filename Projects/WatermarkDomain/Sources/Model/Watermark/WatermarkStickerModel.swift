//
//  WatermarkStickerModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public struct WatermarkStickerModel {
    public var imageData: Data
    public var alpha: CGFloat
    public var position: CGPoint
    public var rotation: CGFloat
    public var scale: CGFloat
    public var layer: Int
    
    public init(
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
