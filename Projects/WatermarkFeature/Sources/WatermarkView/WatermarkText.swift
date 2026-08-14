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
    
    private let watermarkSize: CGSize

    public init(
        watermarkImageSize: CGSize
    ) {
        self.watermarkSize = watermarkImageSize
    }

    public var body: some View {
        GeometryReader { proxy in
            let renderSize = viewModel.format.getRenderSize(
                watermarkSize: watermarkSize,
                containerSize: proxy.size
            )
            let watermarkSize = viewModel.format.getWatermarkImageSize(
                origins: viewModel.picker.images,
                array: viewModel.store.watermark.array
            )
            if watermarkSize.width == .zero || watermarkSize.height == .zero {
                EmptyView()
            } else {
                let renderRatio = renderSize.width / watermarkSize.width
                
                let displayText = viewModel.format.getDisplayText(for: viewModel.store.watermark.text)
                let renderTextAreaSize = viewModel.format.getTextArea(
                    text: displayText,
                    font: viewModel.store.watermark.text.toPFont,
                    fontSize: viewModel.store.watermark.text.fontSize * renderRatio
                )
                let grid = viewModel.format.getTextGrid(
                    renderSize: renderSize,
                    renderTextAreaSize: renderTextAreaSize,
                    spacingRatioW: viewModel.store.watermark.text.spacingWidthRatio,
                    spacingRatioH: viewModel.store.watermark.text.spacingHeightRatio
                )
                WatermarkTextGridLayer(renderData: .init(
                    text: displayText,
                    watermark: viewModel.store.watermark.text,
                    renderRatio: renderRatio,
                    renderTextAreaSize: renderTextAreaSize,
                    renderRows: grid.rows,
                    renderColumns: grid.columns
                ))
                .frame(width: renderSize.width, height: renderSize.height)
                .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
                .overlay(alignment: .center) {
                    if viewModel.isShowEdit {
                        editGuide(renderTextAreaSize: renderTextAreaSize)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func editGuide(renderTextAreaSize size: CGSize) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .stroke(lineWidth: 2)
                .foreground(.white)
                .shadow(.light)
                .frame(width: size.width, height: size.height)
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

private struct WatermarkTextGridViewState {
    let text: String
    let font: PFont
    let color: ColorData
    let spacing: CGSize
    let rotation: CGFloat
    let textArea: CGSize
    let rows: Int
    let columns: Int
    
    init(
        text: String,
        watermark: WatermarkTextModel,
        renderRatio: CGFloat,
        renderTextAreaSize: CGSize,
        renderRows: Int,
        renderColumns: Int
    ) {
        self.text = text
        let fontSize = watermark.fontSize * renderRatio
        self.font = .init(name: watermark.fontName, size: fontSize) ?? PFont.systemFont(ofSize: fontSize)
        self.color = watermark.color
        self.rotation = watermark.rotation
        self.spacing = .init(
            width: watermark.spacingWidthRatio * renderTextAreaSize.width,
            height: watermark.spacingHeightRatio * renderTextAreaSize.height
        )
        self.textArea = renderTextAreaSize
        self.rows = renderRows
        self.columns = renderColumns
    }
}

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
