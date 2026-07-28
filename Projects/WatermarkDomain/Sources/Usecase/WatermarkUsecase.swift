//
//  WatermarkUsecase.swift
//  WatermarkDomain
//
//  Created by AtenB on 5/13/26.
//

import Foundation
import PlatformCore
import CoreDomain

public class WatermarkUsecase {
    let wordDataStore: any WatermarkWordRepository
    let watermarkDataStore: any WatermarkRepository
    let imageExportRepository: any ImageExportRepository

    let format: WatermarkFormat = WatermarkFormat()

    public init(
        wordDataStore: any WatermarkWordRepository,
        watermarkDataStore: any WatermarkRepository,
        imageExportRepository: any ImageExportRepository
    ) {
        self.wordDataStore = wordDataStore
        self.watermarkDataStore = watermarkDataStore
        self.imageExportRepository = imageExportRepository
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
    func saveWatermarkImage(_ images: [PImage]) async -> [Bool] {
        await imageExportRepository.save(images: images)
    }
}
