//
//  WatermarkText.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/21/26.
//

import SwiftUI
import PlatformCore
import Design
import WatermarkDomain

/// 워터마크 텍스트 레이어
public struct WatermarkText: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    private let watermarkSize: CGSize
    
    private let rotation: Angle

    public init(
        watermarkImageSize: CGSize,
        rotation: Angle = .zero
    ) {
        self.watermarkSize = watermarkImageSize
        self.rotation = rotation
    }

    public var body: some View {
        GeometryReader { proxy in
            if let layout = viewModel.makeWatermarkTextLayout(
                watermarkImageSize: watermarkSize,
                containerSize: proxy.size
            ) {
                WatermarkTextGridLayer(renderData: .init(
                    text: layout.displayText,
                    watermark: viewModel.store.watermark.text,
                    renderRatio: layout.renderRatio,
                    renderTextAreaSize: layout.renderTextAreaSize,
                    renderRows: layout.renderRows,
                    renderColumns: layout.renderColumns
                ))
                .frame(width: canvasSize(of: layout).width, height: canvasSize(of: layout).height)
                .rotationEffect(rotation)
                .frame(width: layout.renderSize.width, height: layout.renderSize.height)
                .clipped()
                .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
            }
        }
    }
}

private extension WatermarkText {
    func canvasSize(of layout: WatermarkTextLayout) -> CGSize {
        guard viewModel.mode == .text else { return layout.renderSize }
        let side = hypot(layout.renderSize.width, layout.renderSize.height)
        return CGSize(width: side, height: side)
    }
}

// MARK: - 워터마크 텍스트 레이어(그리드)
private struct WatermarkTextGridLayer: View {
    @EnvironmentObject var viewModel: WatermarkViewModel

    var data: WatermarkTextGridViewState
    
    init(
        renderData data: WatermarkTextGridViewState
    ) {
        self.data = data
    }

    var body: some View {
        Canvas { context, size in
            
            // 이미지 중심을 기준으로 텍스트 그리기
            let centerX = size.width * 0.5
            let centerY = size.height * 0.5

            //
            let stepX = data.textArea.width + data.spacing.width
            let stepY = data.textArea.height + data.spacing.height
            let radians = data.rotation * .pi / 180
            let cosTheta = cos(radians)
            let sinTheta = sin(radians)

            let u = CGVector(dx: cosTheta * stepX, dy: sinTheta * stepX)
            let v = CGVector(dx: -sinTheta * stepY, dy: cosTheta * stepY)

            let halfDiagonal = hypot(size.width, size.height) * 0.5
            let safeStepX = max(stepX, 1)
            let safeStepY = max(stepY, 1)
            let columnRadius = max(Int(ceil(halfDiagonal / safeStepX)) + 2, data.columns / 2 + 2)
            let rowRadius = max(Int(ceil(halfDiagonal / safeStepY)) + 2, data.rows / 2 + 2)

            let attributes: [NSAttributedString.Key: Any] = [
                .font: data.font,
                .foregroundColor: data.color.toPColor
            ]

            let attributedText = NSAttributedString(
                string: data.text,
                attributes: attributes
            )

            let textSize = attributedText.size()
            let resolved = context.resolve(
                Text(data.text)
                    .font(.custom(data.font.fontName, size: data.font.pointSize))
                    .foregroundStyle(data.color.toColor)
            )

            for rowOffset in (-rowRadius)...rowRadius {
                for columnOffset in (-columnRadius)...columnRadius {
                    let x = centerX
                        + CGFloat(columnOffset) * u.dx
                        + CGFloat(rowOffset) * v.dx
                    let y = centerY
                        + CGFloat(columnOffset) * u.dy
                        + CGFloat(rowOffset) * v.dy

                    let drawRect = CGRect(
                        x: -textSize.width * 0.5,
                        y: -textSize.height * 0.5,
                        width: textSize.width,
                        height: textSize.height
                    )

                    context.withCGContext { cgContext in
#if canImport(UIKit)
                        cgContext.saveGState()
                        cgContext.translateBy(x: x, y: y)
                        cgContext.rotate(by: radians)
                        UIGraphicsPushContext(cgContext)
                        attributedText.draw(in: drawRect)
                        UIGraphicsPopContext()
                        cgContext.restoreGState()
#else
                        context.draw(
                            resolved,
                            at: CGPoint(x: x, y: y),
                            anchor: .center
                        )
#endif
                    }
                }
            }
        }
        .drawingGroup()
    }
}
