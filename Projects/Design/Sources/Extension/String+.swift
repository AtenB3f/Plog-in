//
//  String+.swift
//  Design
//
//  Created by AtenB on 11/13/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import PlatformCore

public extension String {
    func getSize(font: PFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size
    }
}
