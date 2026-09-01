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

public extension PImage {
    func toData() -> Data? {
#if os(iOS)
        return self.pngData()
#elseif os(macOS)
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        return rep.representation(using: .png, properties: [:])
#endif
    }
}
