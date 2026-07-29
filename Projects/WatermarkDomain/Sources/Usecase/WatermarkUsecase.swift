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

// MARK: - 워터마크 단어
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

// MARK: - 워터마크 모델
public extension WatermarkUsecase {
    func fetchWatermarks() -> [WatermarkModel] {
        let basic = watermarkDataStore.getWatermarks(type: .basic)
        let custom = watermarkDataStore.getWatermarks(type: .custom)
        
        return basic + custom
    }
    
    func saveWatermark(_ watermark: WatermarkModel) {
        watermarkDataStore.setWatermark(watermark)
    }

    func removeWatermark(id: UUID) {
        watermarkDataStore.removeWatermark(id)
    }
}

// MARK: - 워터마크 이미지 출력
public extension WatermarkUsecase {
    func saveWatermarkImage(_ images: [PImage]) async -> [Bool] {
        await imageExportRepository.save(images: images)
    }
}
