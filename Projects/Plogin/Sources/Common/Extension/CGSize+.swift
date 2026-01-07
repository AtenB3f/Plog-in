//
//  CGSize+.swift
//  Plogin
//
//  Created by AtenB on 12/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public extension CGSize {
    var ratio: CGFloat {
        return self.width/self.height
    }
}
