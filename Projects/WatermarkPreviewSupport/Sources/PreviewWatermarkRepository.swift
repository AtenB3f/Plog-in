//
//  PreviewWatermarkRepository.swift
//  WatermarkPreviewSupport
//

#if DEBUG
import Foundation
import PlatformCore
import WatermarkDomain
import CoreDomain

private final class PreviewWatermarkRepository: WatermarkWordRepository, WatermarkRepository {
    private var words: [WatermarkWordModel] = []
    private var watermarks: [WatermarkModel] = []

    func getWords() -> [WatermarkWordModel] { words }
    func setWord(_ text: String) { words.append(WatermarkWordModel(text: text)) }
    func removeWord(_ text: String) { words.removeAll { $0.text == text } }
    func removeLast() { if !words.isEmpty { words.removeLast() } }

    func getWatermarks() -> [WatermarkModel] { watermarks }
    func setWatermark(_ watermark: WatermarkModel) {
        if let index = watermarks.firstIndex(where: { $0.id == watermark.id }) {
            watermarks[index] = watermark
        } else {
            watermarks.append(watermark)
        }
    }
    func removeWatermark(_ id: UUID) { watermarks.removeAll { $0.id == id } }
    func getWatermarks(type: WatermarkFrameType) -> [WatermarkModel] {
        watermarks.filter { $0.frame.type == type }
    }
}

private final class PreviewImageExportRepository: ImageExportRepository {
    func save(images: [PImage]) async -> [Bool] {
        images.map { _ in true }
    }
}

public func makePreviewWatermarkUsecase() -> WatermarkUsecase {
    let repository = PreviewWatermarkRepository()
    return WatermarkUsecase(
        wordDataStore: repository,
        watermarkDataStore: repository,
        imageExportRepository: PreviewImageExportRepository()
    )
}
#endif
