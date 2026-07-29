//
//  WatermarkStickerModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import PlatformCore

public struct WatermarkStickerModel: Hashable {
    public var image: PImage
    public var alpha: CGFloat
    public var position: CGPoint
    public var rotation: CGFloat
    public var scale: CGFloat
    public var layer: Int

    public init(
        image: PImage,
        alpha: CGFloat,
        position: CGPoint,
        rotation: CGFloat,
        scale: CGFloat,
        layer: Int
    ) {
        self.image = image
        self.alpha = alpha
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.layer = layer
    }
}
