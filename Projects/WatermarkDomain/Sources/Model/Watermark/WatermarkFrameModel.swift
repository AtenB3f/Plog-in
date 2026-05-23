//
//  WatermarkFrameModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public enum WatermarkFrameType: String, Codable {
    case basic
    case custom
}

public struct WatermarkFrameModel {
    public var thumnailData: Data?
    public var title: String
    public var date: Date
    public var lastDate: Date
    public var type: WatermarkFrameType

    public init(thumnail: Data? = nil, title: String = "", type: WatermarkFrameType = .custom) {
        self.thumnailData = thumnail
        self.title = title
        let current = Date()
        self.date = current
        self.lastDate = current
        self.type = type
    }
}
