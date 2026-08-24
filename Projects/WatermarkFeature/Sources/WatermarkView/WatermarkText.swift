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
    
    @GestureState private var rotationAngle: Angle = .zero

    public init(
        watermarkImageSize: CGSize
    ) {
        self.watermarkSize = watermarkImageSize
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
                .rotationEffect(rotationAngle)
                .frame(width: layout.renderSize.width, height: layout.renderSize.height)
                .clipped()
                .contentShape(Rectangle())
                .onTapGesture { viewModel.action(.textMode) }
                .gesture(rotationGesture)
                .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
                
                editGuide(renderTextAreaSize: layout.renderTextAreaSize)
                    .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
            }
        }
    }
    
    @ViewBuilder
    func editGuide(renderTextAreaSize size: CGSize) -> some View {
        if viewModel.mode == .text {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .stroke(lineWidth: 2)
                    .foreground(.white)
                    .shadow(.light)
                    .frame(width: size.width, height: size.height)
                    .rotationEffect(.degrees(viewModel.store.watermark.text.rotation) + rotationAngle)
            }
        }
    }
}

private extension WatermarkText {
    var rotationGesture: some Gesture {
        RotationGesture()
            .updating($rotationAngle) { value, state, _ in
                guard viewModel.editMode?.mode == .text else { return }
                state = value
            }
            .onEnded { value in
                guard viewModel.editMode?.mode == .text else { return }
                viewModel.store.watermark.text.rotation += value.degrees
            }
    }

    func canvasSize(of layout: WatermarkTextLayout) -> CGSize {
        guard viewModel.mode == .text else { return layout.renderSize }
        let side = hypot(layout.renderSize.width, layout.renderSize.height)
        return CGSize(width: side, height: side)
    }
}

public struct WatermarkTextLayout {
    let renderSize: CGSize
    let renderRatio: CGFloat
    let displayText: String
    let renderTextAreaSize: CGSize
    let renderRows: Int
    let renderColumns: Int
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
