//
//  WatermarkUsecase.swift
//  WatermarkDomain
//
//  Created by AtenB on 5/13/26.
//

import Foundation
import PlatformCore

public protocol WatermarkWordRepository {
    func getWords() -> [WatermarkWordModel]
    func setWord(_ text: String)
    func removeWord(_ text: String)
    func removeLast()
}

public protocol WatermarkRepository {
    func getWatermarks() -> [WatermarkModel]
    func setWatermark(_ watermark: WatermarkModel)
    func removeWatermark(_ id: UUID)
    func getWatermarks(type: WatermarkFrameType) -> [WatermarkModel]
}

public class WatermarkUsecase {
    let wordDataStore: any WatermarkWordRepository
    let watermarkDataStore: any WatermarkRepository
    let format: WatermarkFormat = WatermarkFormat()
    
    public init(
        wordDataStore: any WatermarkWordRepository,
        watermarkDataStore: any WatermarkRepository,
    ) {
        self.wordDataStore = wordDataStore
        self.watermarkDataStore = watermarkDataStore
    }
}

public extension WatermarkUsecase {
    func fetchWords() -> [WatermarkWordModel] {
        return wordDataStore.getWords()
    }
    
    /// 최대 10개 저장
    func saveWord(_ text: String) {
        if wordDataStore.getWords().count >= 10 {
            wordDataStore.removeLast()
        }
        wordDataStore.setWord(text)
    }
    
    func removeWord(_ text: String) {
        wordDataStore.removeWord(text)
    }
}

public extension WatermarkUsecase {
    func saveWatermark(_ watermark: WatermarkModel) {
        watermarkDataStore.setWatermark(watermark)
    }

    func removeWatermark(id: UUID) {
        watermarkDataStore.removeWatermark(id)
    }
}

public extension WatermarkUsecase {
    /// export width 기준으로 fontSize/spacing을 재계산하고 나머지 값은 기존 모델 유지 (650px 기준 비율 적용)
    func makeTextModel(export: WatermarkExportModel, current: WatermarkTextModel) -> WatermarkTextModel {
        let ratio = export.width / 650
        var updated = current
        updated.fontSize = ratio * 36
        updated.spacingWidth = ratio * 20
        updated.spacingHeight = ratio * 20
        return updated
    }
}

public extension WatermarkUsecase {
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
