//
//  WatermarkArrayModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData

enum WatermarkArrayType: String, Codable {
    case none
    case horizontal
    case vertical
    case grid
}

@Model
public final class WatermarkArrayModel {
    var type: WatermarkArrayType
    var rows: Int
    var columns: Int
    
    // 역관계를 위한 속성 추가
    var watermark: WatermarkModel?
    
    init(type: WatermarkArrayType, rows: Int, columns: Int) {
        self.type = type
        self.rows = rows
        self.columns = columns
    }
}
