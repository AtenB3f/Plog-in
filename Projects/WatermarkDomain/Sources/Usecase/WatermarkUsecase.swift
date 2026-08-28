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

// MARK: - 워터마크 초기 세팅
public extension WatermarkUsecase {
    /// 이미지가 새로 선택됐을 때 필요한 초기 세팅을 한 번에 적용
    /// 1) 저장된 문구 이력 중 가장 최근 문구를 text에 적용
    /// 2) 이미지 크기 기준 fontSize 재계산 (WatermarkFormat.makeTextModel)
    /// 3) array 타입 기준 출력 사이즈 재계산 (WatermarkFormat.makeExportModel)
    /// 4) text.date가 이미 설정돼 있다면 현재 시각으로 갱신 (nil이면 설정 안함)
    func setupWatermark(origins: [PImage], current: inout WatermarkModel) {
        guard !origins.isEmpty else { return }

        if let recent = fetchWords().first {
            current.text.text = recent.text
        }
        format.makeTextModel(
            origins: origins,
            array: current.array,
            current: &current.text
        )
        current.export = format.makeExportModel(origins: origins, array: current.array)
        if current.text.date != nil {
            current.text.date = Date()
        }
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
