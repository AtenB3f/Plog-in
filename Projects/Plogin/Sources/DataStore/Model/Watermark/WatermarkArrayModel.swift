//
//  WatermarkArrayModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData

public enum WatermarkArrayType: String, Codable, CaseIterable {
    case none
    case horizontal
    case vertical
    case grid
    
    var menuName: String {
        switch self {
        case .none:
            return "개별"
        case .horizontal:
            return "가로"
        case .vertical:
            return "세로"
        case .grid:
            return "바둑판"
        }
    }
}

@Model
public final class WatermarkArrayModel {
    var type: WatermarkArrayType
    var rows: Int
    var columns: Int
    
    var watermark: WatermarkModel?
    
    init(
        type: WatermarkArrayType = .none,
        rows: Int = 1,
        columns: Int = 1
    ) {
        self.type = type
        self.rows = rows
        self.columns = columns
    }
    
    func setRowColumn(_ imageCount: Int) {
        switch type {
        case .none:
            rows = 1
            columns = 1
        case .horizontal:
            rows = imageCount
            columns = 1
        case .vertical:
            rows = 1
            columns = imageCount
        case .grid:
            break
        }
    }
}
