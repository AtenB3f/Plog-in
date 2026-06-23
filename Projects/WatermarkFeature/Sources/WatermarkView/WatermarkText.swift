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

public struct WatermarkText: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    private let imageSize: CGSize

    public init(
        imageSize: CGSize
    ) {
        self.imageSize = imageSize
    }

    public var body: some View {
        GeometryReader { proxy in
            let renderSize = viewModel.format.getRenderSize(
                originSize: imageSize,
                containerSize: proxy.size
            )

            if renderSize != .zero, viewModel.store.watermark.text.fontSize > 0 {

            let exportWidth = viewModel.store.watermark.export.width
            let renderRatio = exportWidth > 0 ? renderSize.width / exportWidth : renderSize.width / imageSize.width
            
            let renderFontSize = viewModel.store.watermark.text.fontSize * renderRatio
            let renderKerning = -0.25 * renderFontSize / 36

            let renderCellSize = viewModel.format.getTextCellSize(
                text: viewModel.store.watermark.text.text + " " + (viewModel.store.watermark.text.date?.now() ?? ""),
                font: viewModel.store.watermark.text.toPFont,
                fontSize: renderFontSize,
                kerning: renderKerning
            )
            
            let grid = viewModel.format.getGrid(
                renderSize: renderSize,
                cellSize: renderCellSize,
                spacingHorizontal: viewModel.store.watermark.text.spacingWidth * renderRatio,
                spacingVertical: viewModel.store.watermark.text.spacingHeight * renderRatio
            )

            GridLayer(
                proxy: proxy,
                watermarkText: viewModel.store.watermark.text,
                renderRatio: renderRatio,
                renderSize: renderSize,
                renderFontSize: renderFontSize,
                cellSize: renderCellSize,
                rows: grid.rows,
                columns: grid.columns
            )
            .frame(width: renderSize.width, height: renderSize.height)
            .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
            .overlay(alignment: .center) {
                if viewModel.isShowEdit {
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .stroke(lineWidth: 2)
                            .foreground(.white)
                            .shadow(.light)
                            .frame(width: renderCellSize.width, height: renderCellSize.height)
                            .rotationEffect(.degrees(viewModel.store.watermark.text.rotation))

                        Image.iconCloseCircle
                            .frame(width: 16, height: 16)
                            .background {
                                Circle()
                                    .frame(width: 16, height: 16)
                                    .foreground(.white)
                            }
                            .foreground(.Gray.light)
                            .offset(x: 8, y: -8)
                            .onTapGesture {
                                viewModel.action(.textMode(isOn: false))
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct GridLayer: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    let proxy: GeometryProxy
    let watermarkText: WatermarkTextModel

    let renderRatio: CGFloat
    let renderSize: CGSize
    let renderFontSize: CGFloat

    let cellSize: CGSize

    let rows: Int
    let columns: Int

    var body: some View {
        Canvas { context, size in
            let centerX = size.width * 0.5
            let centerY = size.height * 0.5

            let stepX = cellSize.width + watermarkText.spacingWidth * renderRatio
            let stepY = cellSize.height + watermarkText.spacingHeight * renderRatio
            let renderKerning = -0.25 * renderRatio
            let radians = watermarkText.rotation * .pi / 180
            let cosTheta = cos(radians)
            let sinTheta = sin(radians)

            let u = CGVector(dx: cosTheta * stepX, dy: sinTheta * stepX)
            let v = CGVector(dx: -sinTheta * stepY, dy: cosTheta * stepY)

            let halfDiagonal = hypot(size.width, size.height) * 0.5
            let safeStepX = max(stepX, 1)
            let safeStepY = max(stepY, 1)
            let columnRadius = max(Int(ceil(halfDiagonal / safeStepX)) + 2, columns / 2 + 2)
            let rowRadius = max(Int(ceil(halfDiagonal / safeStepY)) + 2, rows / 2 + 2)

            let drawFont = PFont(
                name: watermarkText.fontName,
                size: renderFontSize
            ) ?? .systemFont(ofSize: renderFontSize)

            let attributes: [NSAttributedString.Key: Any] = [
                .font: drawFont,
                .kern: renderKerning,
                .foregroundColor: watermarkText.color.toPColor
            ]

            let attributedText = NSAttributedString(
                string: watermarkText.text + " " + (watermarkText.date?.now() ?? ""),
                attributes: attributes
            )

            let textSize = attributedText.size()
            let resolved = context.resolve(
                Text(watermarkText.text + " " + (watermarkText.date?.now() ?? ""))
                    .font(.custom(watermarkText.fontName, size: renderFontSize))
                    .kerning(renderKerning)
                    .foregroundStyle(watermarkText.color.toColor)
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
