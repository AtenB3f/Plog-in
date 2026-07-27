//
//  PImage+TestFixture.swift
//  WatermarkDomainTests
//

import PlatformCore

#if os(iOS)
import UIKit

extension PImage {
    /// 픽셀 내용 없이 `.size`만 정확한, 테스트 전용 더미 이미지
    static func testFixture(width: CGFloat, height: CGFloat) -> PImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format)
        return renderer.image { _ in }
    }
}

#elseif os(macOS)
import AppKit

extension PImage {
    static func testFixture(width: CGFloat, height: CGFloat) -> PImage {
        NSImage(size: CGSize(width: width, height: height))
    }
}
#endif
