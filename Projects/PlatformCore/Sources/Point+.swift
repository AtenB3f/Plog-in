//
//  Point+.swift
//  Plogin
//
//  Created by AtenB on 8/24/26.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

// CGPoint 래퍼
public struct PointData: Codable, Equatable, Hashable {
    public var x: CGFloat
    public var y: CGFloat

    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    enum CodingKeys: String, CodingKey {
        case x, y
    }
}

public extension PointData {
    var point: CGPoint {
        CGPoint(x: x, y: y)
    }

    init(_ point: CGPoint) {
        self.init(x: point.x, y: point.y)
    }
}
