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
    /// 이미지 리스트 중 첫 번째 이미지의 너비와 기준 이미지 너비로 이미지들의 너비를 조정했을 때 가장 값이 큰 높이를 구하는 함수
    func getCellSize(images: [PImage]) -> CGSize {
        // 첫 번째 이미지를 기준으로 설정
        let referenceImage = images[0]
        var cellSize = referenceImage.size
        cellSize.height = (images.map { $0.size.height/$0.size.width }.max() ?? 1.0) * referenceImage.size.width
        
        return cellSize
    }
    
    func getCellRatio(images: [PImage]) -> CGFloat {
        let size = getCellSize(images: images)
        return size.width / size.height
    }
    
    func getCell(images: [PImage], array: WatermarkArrayModel) -> CGSize {
        let cell = getCellSize(images: images)
        return CGSize(
            width: cell.width * CGFloat(array.columns),
            height: cell.height * CGFloat(array.rows)
        )
    }

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
}

public extension WatermarkFormat {
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

public extension WatermarkFormat {
    /// fontSize/spacing을 재계산하고 나머지 값은 기존 모델 유지 (650px 기준 비율 적용)
    func makeTextModel(
        origins: [PImage],
        array: WatermarkArrayModel,
        current: inout WatermarkTextModel
    ) {
        var imageSize: CGSize = .zero
        switch array.type {
        case .none:
            imageSize.width = origins.first?.size.width ?? .zero
            imageSize.height = origins.first?.size.height ?? .zero
        case .horizontal:
            let cellSize = getCellSize(origins: origins, row: 1, columns: origins.count)
            imageSize = .init(width: cellSize.width * CGFloat(origins.count), height: cellSize.height)
        case .vertical:
            let cellSize = getCellSize(origins: origins, row: origins.count, columns: 1)
            imageSize = .init(width: cellSize.width, height: cellSize.height * CGFloat(origins.count))
        case .grid:
            let cellSize = getCellSize(origins: origins, row: array.rows, columns: array.columns)
            imageSize = .init(width: cellSize.width * CGFloat(array.columns), height: cellSize.height * CGFloat(array.rows))
        }
        let ratio = imageSize.width / 650
        current.fontSize = ratio * 36
        current.spacingWidth = ratio * 20
        current.spacingHeight = ratio * 20
    }
    
    func getCellSize(origins: [PImage], row: Int, columns: Int) -> CGSize {
        guard let first = origins.first else { return .zero }
        if row > columns {
            if CGFloat(row) * first.size.height > 1500 {
                let height = CGFloat(1500)/CGFloat(origins.count)
                let ratio = CGFloat(height)/first.size.height
                let width = CGFloat(first.size.width) * ratio
                return .init(width: width, height: height)
            } else {
                return .init(width: first.size.width * CGFloat(columns), height: first.size.height * CGFloat(row))
            }
        } else {
            if CGFloat(columns) * first.size.width > 1500 {
                let width = CGFloat(1500)/CGFloat(origins.count)
                let ratio = CGFloat(width)/first.size.width
                let height = CGFloat(first.size.height) * ratio
                return .init(width: width, height: height)
            } else {
                return .init(width: first.size.width * CGFloat(columns), height: first.size.height * CGFloat(row))
            }
        }
    }
}

public extension WatermarkFormat {
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
