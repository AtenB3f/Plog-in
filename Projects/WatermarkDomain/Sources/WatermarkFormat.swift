//
//  WatermarkFormat.swift
//  WatermarkDomain
//
//  Created by AtenB on 4/27/26.
//

import PlatformCore
import SwiftUI

public class WatermarkFormat {
    public init() {}
}

public extension WatermarkFormat {
    /// origins 중 width / height 가 가장 작은 값
    func getCellRatio(origins: [PImage]) -> CGFloat {
        guard let max = origins.map({ $0.size.height / $0.size.width }).sorted(by: <).last else { return 1 }
        return 1/max
    }
    
    /// Cell Size에서 행렬을 곱한 값
    func getGridSize(origins: [PImage], rows: Int, columns: Int) -> CGSize {
        guard let referenceImage = origins.first else { return .zero }
        let cellWidth = referenceImage.size.width
        let cellHeight = cellWidth / getCellRatio(origins: origins)
        return .init(
            width: cellWidth * CGFloat(columns),
            height: cellHeight * CGFloat(rows)
        )
    }
    
    // 워터마크 이미지 내의 셀의 사이즈
    func getCellSize(origins: [PImage], array: WatermarkArrayModel) -> CGSize {
        let rows = array.rows
        let columns = array.columns
        let gridSize = getGridSize(origins: origins, rows: rows, columns: columns)
        let cellRatio = getCellRatio(origins: origins)
        
        guard let first = origins.first else { return .zero }
        
        switch array.type {
        case .none:
            return first.size
        case .horizontal:
            if gridSize.width > 1500 {
                let width = 1500 / CGFloat(origins.count)
                let height = width / cellRatio
                return .init(width: width, height: height)
            } else {
                return .init(width: first.size.width, height: first.size.width / cellRatio)
            }
        case .vertical:
            if gridSize.height > 1500 {
                let height = 1500 / CGFloat(origins.count)
                let width = height * cellRatio
                return .init(width: width, height: height)
            } else {
                return .init(width: first.size.height / cellRatio, height: first.size.height)
            }
        case .grid:
            if gridSize.height > gridSize.width {
                if gridSize.height > 1500 {
                    let height = CGFloat(1500)/CGFloat(rows)
                    let ratio = 1500 / gridSize.height
                    let width = gridSize.width * ratio / CGFloat(columns)
                    return .init(width: width, height: height)
                } else {
                    return first.size
                }
            } else {
                if gridSize.width > 1500 {
                    let width = CGFloat(1500)/CGFloat(columns)
                    let ratio = 1500 / gridSize.width
                    let height = gridSize.height * ratio / CGFloat(rows)
                    return .init(width: width, height: height)
                } else {
                    return first.size
                }
            }
        }
    }
    
    // 워터마크 이미지 사이즈
    func getWatermarkImageSize(origins: [PImage], array: WatermarkArrayModel) -> CGSize {
        let cell = getCellSize(origins: origins, array: array)
        switch array.type {
        case .none:
            return cell
        case .horizontal, .vertical, .grid:
            return CGSize(
                width: cell.width * CGFloat(array.columns),
                height: cell.height * CGFloat(array.rows)
            )
        }
    }
}

public extension WatermarkFormat {
    /// fontSize/spacing을 재계산하고 나머지 값은 기존 모델 유지 (650px 기준 비율 적용)
    func makeTextModel(
        origins: [PImage],
        array: WatermarkArrayModel,
        current: inout WatermarkTextModel
    ) {
        var imageSize: CGSize = .zero
        let cellSize = getCellSize(origins: origins, array: array)
        switch array.type {
        case .none:
            imageSize.width = origins.first?.size.width ?? .zero
            imageSize.height = origins.first?.size.height ?? .zero
        case .horizontal:
            imageSize = .init(width: cellSize.width * CGFloat(origins.count), height: cellSize.height)
        case .vertical:
            imageSize = .init(width: cellSize.width, height: cellSize.height * CGFloat(origins.count))
        case .grid:
            imageSize = .init(width: cellSize.width * CGFloat(array.columns), height: cellSize.height * CGFloat(array.rows))
        }
        let ratio = imageSize.width / 650
        current.fontSize = ratio * 36
    }
    
    /// - Parameters:
    ///   - stickers: 스티커 이미지 배열
    ///   - origins: 원본 이미지 배열
    ///   - array: 배열 모델
    func makeStickerModels(
        stickers: [PImage],
        origins: [PImage],
        array: WatermarkArrayModel
    ) -> [WatermarkStickerModel] {
        let watermarkImageWidth = getWatermarkImageSize(origins: origins, array: array).width
        return stickers.enumerated().map { index, image in
            let scale = (watermarkImageWidth / 3) / image.size.width
            return WatermarkStickerModel(
                image: image,
                alpha: 1.0,
                position: .zero,
                rotation: 0.0,
                scale: scale,
                layer: index
            )
        }
    }

    /// 워터마크 이미지 크기 변화 비율만큼 기존 스티커의 scale을 재조정
    func rescaleStickers(
        _ stickers: [WatermarkStickerModel],
        oldWidth: CGFloat,
        newWidth: CGFloat
    ) -> [WatermarkStickerModel] {
        guard oldWidth > 0, oldWidth != newWidth else { return stickers }
        let ratio = newWidth / oldWidth
        return stickers.map { sticker in
            var updated = sticker
            updated.scale *= ratio
            return updated
        }
    }
    
    func makeArrayModel(
        origins: [PImage],
        type: WatermarkArrayType,
        current: WatermarkArrayModel
    ) -> WatermarkArrayModel {
        var model = current
        model.type = type
        switch type {
        case .none:
            model.rows = 1
            model.columns = 1
        case .horizontal:
            model.rows = 1
            model.columns = origins.count
        case .vertical:
            model.rows = origins.count
            model.columns = 1
        case .grid:
            model.rows = 1
            model.columns = 1
        }
        return model
    }

    /// max 너비 1500px로 제한
    /// auto 타입인 경우 사용
    func makeExportModel(
        origins: [PImage],
        array: WatermarkArrayModel
    ) -> WatermarkExportModel {
        let max: CGFloat = 1500
        var width: CGFloat = origins.first?.size.width ?? 0
        var height: CGFloat = origins.first?.size.height ?? 0
        var ratio: CGFloat = 1.0

        let totalW = width * CGFloat(array.columns)
        let totalH = height * CGFloat(array.rows)

        switch array.type {
        case .none:
            break
        case .horizontal:
            if totalW >= max {
                ratio = max / totalW
                width = max
                height *= ratio
            } else {
                width *= CGFloat(array.columns)
            }
        case .vertical:
            if totalH >= max {
                ratio = max / totalH
                height = max
                width *= ratio
            } else {
                height *= CGFloat(array.rows)
            }
        case .grid:
            if width > height {
                if totalW >= max {
                    ratio = max / totalW
                    width = max
                    height = totalH * ratio
                } else {
                    width = totalW
                    height = totalH
                }
            } else {
                if totalH >= max {
                    ratio = max / totalH
                    height = max
                    width = totalW * ratio
                } else {
                    width = totalW
                    height = totalH
                }
            }
        }
        return .init(
            type: .auto,
            width: width,
            height: height,
            multiple: 1.0
        )
    }
    
    /// max 너비 3000px로 제한
    /// multiple 타입인 경우 사용
    func makeExportModel(
        origins: [PImage],
        array: WatermarkArrayModel,
        multiple: CGFloat
    ) -> WatermarkExportModel {
        let max: CGFloat = 3000
        var width: CGFloat = origins.first?.size.width ?? 0
        var height: CGFloat = origins.first?.size.height ?? 0
        var ratio: CGFloat = 1.0
        
        switch array.type {
        case .none:
            width *= multiple
            height *= multiple
        case .horizontal:
            if width * CGFloat(array.columns) * multiple >= max {
                ratio = max / (width * CGFloat(array.columns) * multiple)
                width = max
                height *= ratio
            } else {
                width = width * CGFloat(array.columns) * multiple
                height *= multiple
            }
        case .vertical:
            if height * CGFloat(array.rows) * multiple >= max {
                ratio = max / (height * CGFloat(array.rows) * multiple)
                height = max
                width *= ratio
            } else {
                width *= multiple
                height *= CGFloat(array.rows) * multiple
            }
        case .grid:
            let totalW = width * CGFloat(array.columns) * multiple
            let totalH = height * CGFloat(array.rows) * multiple
            if width > height {
                if totalW >= max {
                    ratio = max / totalW
                    width = max
                    height = totalH * ratio
                } else {
                    width = totalW
                    height = totalH
                }
            } else {
                if totalH >= max {
                    ratio = max / totalH
                    height = max
                    width = totalW * ratio
                } else {
                    width = totalW
                    height = totalH
                }
            }
        }
        return .init(
            type: .multiple,
            width: width,
            height: height,
            multiple: multiple
        )
    }
}

public extension WatermarkFormat {
    func getRowColums(imageCount: Int, array: WatermarkArrayModel) -> (Int, Int) {
        let arrayType = array.type
        var rows = 1
        var columns = 1
        switch arrayType {
        case .none:
            break
        case .horizontal:
            columns = imageCount
            rows = 1
        case .vertical:
            rows = imageCount
            columns = 1
        case .grid:
            rows = array.rows
            columns = array.columns
        }
        return (rows, columns)
    }
    
    func getRenderSize(watermarkSize: CGSize, containerSize: CGSize) -> CGSize {
        guard watermarkSize.width > 0, watermarkSize.height > 0 else { return .zero }

        let widthRatio = containerSize.width / watermarkSize.width
        let heightRatio = containerSize.height / watermarkSize.height

        let scale = min(widthRatio, heightRatio)
        return CGSize(
            width: watermarkSize.width * scale,
            height: watermarkSize.height * scale
        )
    }
    
    func getRenderRatio(
        originSize: CGSize,
        renderSize: CGSize
    ) -> CGFloat {
        guard originSize.width > 0 else { return 1 }
        return renderSize.width / originSize.width
    }
    
    // spacing을 제외하고 Text를 그릴 때의 텍스트 너비
    func getTextArea(
        text: String,
        font: PFont,
        fontSize: CGFloat
    ) -> CGSize {
        let renderFont = font.withSize(fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: renderFont
        ]
        
        let textSize = (text as NSString)
            .size(withAttributes: attributes)
        return textSize
    }
    
    func getTextGrid(
        renderSize: CGSize,
        renderTextAreaSize: CGSize,
        spacingRatioW: CGFloat,
        spacingRatioH: CGFloat
    ) -> (rows: Int, columns: Int) {

        let stepX = renderTextAreaSize.width + renderTextAreaSize.width * spacingRatioW
        let stepY = renderTextAreaSize.height + renderTextAreaSize.height * spacingRatioH

        let columns = Int(ceil(renderSize.width / stepX)) + 2
        let rows = Int(ceil(renderSize.height / stepY)) + 2

        return (rows, columns)
    }
}
