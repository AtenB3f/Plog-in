//
//  WatermarkArrayEntity.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import WatermarkDomain

@Model
public final class WatermarkArrayEntity {
    public var type: WatermarkArrayType
    public var rows: Int
    public var columns: Int
    
    var watermark: WatermarkEntity?
    
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
