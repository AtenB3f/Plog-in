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
    /// origins 중 height / width 가 가장 큰 값
    func getCellRatio(origins: [PImage]) -> CGFloat {
        guard let max = origins.map({ $0.size.height / $0.size.width }).sorted(by: <).last else { return 1 }
        return max
    }
    
    /// Cell Size에서 행렬을 곱한 값
    func getGridSize(origins: [PImage], rows: Int, columns: Int) -> CGSize {
        guard let referenceImage = origins.first else { return .zero }
        let cellWidth = referenceImage.size.width
        let cellHeight = cellWidth * getCellRatio(origins: origins)
        return .init(
            width: cellWidth * CGFloat(columns),
            height: cellHeight * CGFloat(rows)
        )
    }
    
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
                let height = width * cellRatio
                return .init(width: width, height: height)
            } else {
                return .init(width: first.size.width, height: first.size.width * cellRatio)
            }
        case .vertical:
            if gridSize.height > 1500 {
                let height = 1500 / CGFloat(origins.count)
                let width = height / cellRatio
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
    
    func getWatermarkImageSize(origins: [PImage], array: WatermarkArrayModel) -> CGSize {
        let cell = getCellSize(origins: origins, array: array)
        return CGSize(
            width: cell.width * CGFloat(array.columns),
            height: cell.height * CGFloat(array.rows)
        )
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
    ///   - origin: 기준 이미지 (picker의 첫 번째 이미지) — 너비 1/3 기준으로 scale 계산
    func makeStickerModels(stickers: [PImage], origin: PImage) -> [WatermarkStickerModel] {
        let width = origin.size.width
        return stickers.enumerated().map { index, image in
            let scale = (width / 3) / image.size.width
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
    
    func getRenderSize(originSize: CGSize, containerSize: CGSize) -> CGSize {
        guard originSize.width > 0, originSize.height > 0 else { return .zero }

        let widthRatio = containerSize.width / originSize.width
        let heightRatio = containerSize.height / originSize.height

        let scale = min(widthRatio, heightRatio)

        return CGSize(
            width: originSize.width * scale,
            height: originSize.height * scale
        )
    }
    
    func getRenderRatio(
        originSize: CGSize,
        renderSize: CGSize
    ) -> CGFloat {
        guard originSize.width > 0 else { return 1 }
        return renderSize.width / originSize.width
    }
    
    func getTextCellSize(
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
    
    func getGrid(
        renderSize: CGSize,
        cellSize: CGSize,
        spacingHorizontal: CGFloat,
        spacingVertical: CGFloat
    ) -> (rows: Int, columns: Int) {

        let stepX = cellSize.width + spacingHorizontal
        let stepY = cellSize.height + spacingVertical

        let columns = Int(ceil(renderSize.width / stepX)) + 2
        let rows = Int(ceil(renderSize.height / stepY)) + 2

        return (rows, columns)
    }
}
