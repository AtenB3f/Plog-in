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

public struct WatermarkFrameModel: Identifiable, Hashable {
    public let id: UUID
    public var code: String
    public var thumbnailData: Data?
    public var title: String
    public var date: Date
    public var lastDate: Date
    public var type: WatermarkFrameType

    /// WatermarkFrameType가 .custom인 경우 사용
    public init(
        thumnail: PImage,
        title: String = ""
    ) {
        self.id = UUID()
        self.thumbnailData = thumnail.pngData()
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = .custom
        self.code = id.uuidString
    }
    
    /// WatermarkFrameType가 .basic인 경우 사용
    public init(
        thumnail: PImage,
        title: String = "",
        code: String
    ) {
        self.id = UUID()
        self.thumbnailData = thumnail.pngData()
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = .basic
        self.code = code
    }
    
    /// WatermarkFrameType가 .custom인 경우 사용
    public init(
        thumbnailData: Data? = nil,
        title: String = ""
    ) {
        self.id = UUID()
        self.thumbnailData = thumbnailData
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = .custom
        self.code = id.uuidString
    }
    
    /// WatermarkFrameType가 .basic인 경우 사용
    public init(
        thumbnailData: Data? = nil,
        title: String = "",
        code: String
    ) {
        self.id = UUID()
        self.thumbnailData = thumbnailData
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = .basic
        self.code = code
    }
}
