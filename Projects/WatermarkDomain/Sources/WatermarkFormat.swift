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
