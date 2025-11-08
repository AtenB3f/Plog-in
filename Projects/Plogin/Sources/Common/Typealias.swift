//
//  Typealias.swift
//  Plogin
//
//  Created by AtenB on 11/6/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct SizeData: Codable {
    var width: CGFloat
    var height: CGFloat
    
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

// CGPoint 래퍼
public struct PointData: Codable {
    var x: CGFloat
    var y: CGFloat
    
    var point: CGPoint {
        CGPoint(x: x, y: y)
    }
    
    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
