//
//  WatermarkExportModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData

enum WatermarkExportType: String, Codable {
    case auto
    case multifple
}

@Model
public final class WatermarkExportModel {
    var type: WatermarkExportType
    var width: CGFloat
    var height: CGFloat
    
    var watermark: WatermarkModel?
    
    init(type: WatermarkExportType = .auto, size: CGSize = .zero) {
        self.type = type
        self.width = size.width
        self.height = size.height
    }
}

extension WatermarkExportModel {
    func getRect() -> CGSize {
        return .init(width: self.width, height: self.height)
    }
}
