//
//  Image+.swift
//  PlatformCore
//
//  Created by AtenB on 5/19/26.
//

import SwiftUI

public extension Image {
    init(pImage: PImage) {
#if os(iOS)
        self.init(uiImage: pImage)
#elseif os(macOS)
        self.init(nsImage: pImage)
#endif
    }
}
