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
    // Data, CGPoint 등 Codable을 구현한 타입은 기본적으로 저장 가능합니다.
    var image: Data?
    var alpha: CGFloat
    var position: CGPoint
    var rotation: CGFloat
    var scale: CGFloat
    var layer: Int
    
    // 역관계를 위한 속성 추가
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
