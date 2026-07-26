//
//  WatermarkFrameModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import PlatformCore

public enum WatermarkFrameType: String, Codable {
    case basic
    case custom
}

public struct WatermarkFrameModel: Identifiable {
    public let id: UUID
    public var thumbnailData: Data?
    public var title: String
    public var date: Date
    public var lastDate: Date
    public var type: WatermarkFrameType

    public init(
        thumnail: PImage,
        title: String = "",
        type: WatermarkFrameType = .custom
    ) {
        self.id = UUID()
        self.thumbnailData = thumnail.pngData()
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = type
    }
    
    public init(
        thumbnailData: Data? = nil,
        title: String = "",
        type: WatermarkFrameType = .custom
    ) {
        self.id = UUID()
        self.thumbnailData = thumbnailData
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = type
    }
}
