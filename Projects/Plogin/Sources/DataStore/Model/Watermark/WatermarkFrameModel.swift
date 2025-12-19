//
//  WatermarkFrameModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData
import Design

enum WatermarkFrameType: String, Codable {
    case basic
    case custom
}

@Model
public final class WatermarkFrameModel {
    var thumnailData: Data?
    var title: String
    var date: Date
    var lastDate: Date
    var type: WatermarkFrameType
    var thumbnail: PImage? {
        get {
            guard let data = thumnailData else { return nil }
            return PImage(data: data)
        }
    }
    
    // 역관계를 위한 속성 추가
    var watermark: WatermarkModel?
    
    init(thumnail: PImage? = nil, title: String = "", type: WatermarkFrameType = .custom) {
        self.thumnailData = thumnail?.pngData()
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = type
    }
}
