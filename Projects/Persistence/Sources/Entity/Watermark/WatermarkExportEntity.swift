//
//  WatermarkExportModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import WatermarkDomain

@Model
public final class WatermarkExportEntity {
    public var type: WatermarkExportType
    public var width: CGFloat
    public var height: CGFloat
    public var multiple: CGFloat
    
    var watermark: WatermarkEntity?
    
    public init(type: WatermarkExportType = .auto, size: CGSize = .zero, multiple: CGFloat = 1) {
        self.type = type
        self.width = size.width
        self.height = size.height
        self.multiple = multiple
    }
}
