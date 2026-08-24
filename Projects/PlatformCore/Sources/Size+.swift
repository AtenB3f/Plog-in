//
//  Size+.swift
//  Plogin
//
//  Created by AtenB on 8/24/26.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

// CGSize 래퍼
public struct SizeData: Codable, Equatable, Hashable {
    public var width: CGFloat
    public var height: CGFloat

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    enum CodingKeys: String, CodingKey {
        case width, height
    }
}

public extension SizeData {
    var size: CGSize {
        CGSize(width: width, height: height)
    }

    init(_ size: CGSize) {
        self.init(width: size.width, height: size.height)
    }
}
