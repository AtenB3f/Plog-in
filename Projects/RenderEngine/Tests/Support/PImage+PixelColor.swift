//
//  PImage+PixelColor.swift
//  RenderEngineTests
//
//  RenderEngineTests 타겟은 iPhone(.iOS) 대상으로만 빌드되므로 UIImage 기준으로 작성
//

import CoreGraphics
import PlatformCore

/// 테스트에서 픽셀 값을 다루기 위한 값 타입 (SwiftLint large_tuple 회피 목적으로 tuple 대신 struct 사용)
struct PixelRGBA {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
}

extension PImage {
    /// 이미지 좌상단 기준 (x, y) 픽셀의 RGBA 값을 0...255 범위로 반환 (테스트 전용)
    func pixelColor(atX x: Int, y: Int) -> PixelRGBA? {
        guard let cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        guard x >= 0, y >= 0, x < width, y < height else { return nil }

        var pixel = [UInt8](repeating: 0, count: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.draw(
            cgImage,
            in: CGRect(x: -CGFloat(x), y: -CGFloat(height - y - 1), width: CGFloat(width), height: CGFloat(height))
        )

        return PixelRGBA(r: pixel[0], g: pixel[1], b: pixel[2], a: pixel[3])
    }
}
