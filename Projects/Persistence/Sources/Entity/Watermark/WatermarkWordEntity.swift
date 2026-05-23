//
//  WatermarkWordEntity.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class WatermarkWordEntity {
    public var text: String {
        didSet {
            date = Date()
        }
    }
    public var date: Date
    
    public init(
        text: String
    ) {
        self.text = text
        self.date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case text, date
    }
}
