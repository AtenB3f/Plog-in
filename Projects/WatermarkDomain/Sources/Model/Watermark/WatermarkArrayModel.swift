//
//  WatermarkArrayModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public enum WatermarkArrayType: String, Codable, CaseIterable {
    case none
    case horizontal
    case vertical
    case grid
    
    public var menuName: String {
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

public struct WatermarkArrayModel: Hashable {
    public var type: WatermarkArrayType
    public var rows: Int
    public var columns: Int
    
    public init(
        type: WatermarkArrayType = .none,
        rows: Int = 1,
        columns: Int = 1
    ) {
        self.type = type
        self.rows = rows
        self.columns = columns
    }
}

public extension WatermarkArrayModel {
    mutating func setRowColumn(_ imageCount: Int) {
        switch type {
        case .none:
            rows = 1
            columns = 1
        case .horizontal:
            rows = 1
            columns = imageCount
        case .vertical:
            rows = imageCount
            columns = 1
        case .grid:
            break
        }
    }
}
