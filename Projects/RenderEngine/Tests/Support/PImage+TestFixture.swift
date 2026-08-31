//
//  PImage+TestFixture.swift
//  RenderEngineTests
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

    /// 단색으로 채워진 테스트 전용 더미 이미지 (픽셀 반영 여부 확인용)
    static func testFixture(width: CGFloat, height: CGFloat, fillColor: PColor) -> PImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format)
        return renderer.image { context in
            fillColor.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
    }
}

#elseif os(macOS)
import AppKit

extension PImage {
    static func testFixture(width: CGFloat, height: CGFloat) -> PImage {
        NSImage(size: CGSize(width: width, height: height))
    }

    static func testFixture(width: CGFloat, height: CGFloat, fillColor: PColor) -> PImage {
        let image = NSImage(size: CGSize(width: width, height: height))
        image.lockFocus()
        fillColor.setFill()
        NSRect(x: 0, y: 0, width: width, height: height).fill()
        image.unlockFocus()
        return image
    }
}
#endif
