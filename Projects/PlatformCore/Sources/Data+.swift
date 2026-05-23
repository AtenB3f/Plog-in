//
//  Data+.swift
//  PlatformAdapter
//
//  Created by AtenB on 4/3/26.
//

import Foundation

public extension Data {
    var image: PImage? {
        return PImage(data: self)
    }
}
