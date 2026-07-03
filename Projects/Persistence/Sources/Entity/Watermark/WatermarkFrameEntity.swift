//
//  WatermarkFrameEntity.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import WatermarkDomain

@Model
public final class WatermarkFrameEntity {
    public var id: UUID
    public var thumbnailData: Data?
    public var title: String
    public var date: Date
    public var lastDate: Date
    public var type: WatermarkFrameType
    
    // 역관계를 위한 속성 추가
    var watermark: WatermarkEntity?
    
    public init(
        id: UUID,
        thumnail: Data? = nil,
        title: String = "",
        type: WatermarkFrameType = .custom
    ) {
        self.id = id
        self.thumbnailData = thumnail
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = type
    }
}
