//
//  WatermarkViewState.swift
//  WatermarkFeature
//
//  Created by AtenB on 8/24/26.
//

import Foundation
import PlatformCore
import Design
import WatermarkDomain

public struct WatermarkTextLayout {
    let renderSize: CGSize
    let renderRatio: CGFloat
    let displayText: String
    let renderTextAreaSize: CGSize
    let renderRows: Int
    let renderColumns: Int
}

public struct WatermarkTextGridViewState {
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
