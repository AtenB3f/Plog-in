//
//  PreviewImage.swift
//  WatermarkPreviewSupport
//

#if DEBUG
import CoreGraphics
import PlatformCore

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public func makePreviewImage() -> PImage {
    let size = CGSize(width: 300, height: 600)
#if os(iOS)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        UIColor.systemGray4.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
    }
#elseif os(macOS)
    let image = NSImage(size: size)
    image.lockFocus()
    NSColor.lightGray.setFill()
    NSRect(origin: .zero, size: size).fill()
    image.unlockFocus()
    return image
#endif
}
#endif
