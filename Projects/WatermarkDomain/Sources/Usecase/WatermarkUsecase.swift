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
