//
//  WatermarkViewModel.swift
//  Plogin
//
//  Created by AtenB on 12/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import Design

public class WatermarkViewModel: ObservableObject {
    let editor = WatermarkManager()
    let dataManager = DataStore.shared
    @Published var watermark = WatermarkModel()
    
    // Pickture
    @Published var originImages: [AssetData] = [] {
        didSet {
            images = originImages.compactMap {
                if let data = $0.imageAsset?.pngData() {
                    return PImage(data: data)
                } else { return nil }
            }
            calculateSetting()
        }
    }
    @Published var images: [PImage] = []
    @Published var results: [PImage] = [] // 워터마크 이미지 생성물
    
    // Text
    @Published var textEditMode: Bool = false
    
    // Sticker
    @Published var originSticker: [AssetData] = [] {
        didSet {
            stickers = originSticker.compactMap {
                if let data = $0.imageAsset?.pngData() {
                    return PImage(data: data)
                } else { return nil }
            }
        }
    }
    @Published var stickers: [PImage] = [] {
        didSet {
            watermark.stickers = stickers.enumerated().map { index, image in
                return .init(
                    image: image,
                    alpha: 1.0,
                    position: .zero,
                    rotation: 0,
                    scale: 1.0,
                    layer: index)
            }
        }
    }
    @Published var selectSticker: Int?
    
    init() {
        let words = dataManager.loadWatermarkWord().map { $0.text }
        watermark.textSetting.text = words.first ?? ""
    }
}

public extension WatermarkViewModel {
    func calculateSetting() {
        
        switch watermark.arraySetting.type {
        case .none:
            guard let size = images.first?.size else { break }
            watermark.exportSetting.width = size.width
            watermark.exportSetting.height = size.height
        default:
            let size = editor.getCellSize(images: images)
            let multiple = watermark.exportSetting.multiple
            watermark.exportSetting.width = size.width * multiple
            watermark.exportSetting.height = size.height * multiple
        }
    }
    
    func generateResults() {
        results = editor.generateWatermarks(images, watermark: watermark)
    }
}

public extension WatermarkViewModel {
    func setArray(
        type: WatermarkArrayType? = nil,
        rows: Int? = nil,
        columns: Int? = nil
    ) {
        if let type = type {
            watermark.arraySetting.type = type
            watermark.arraySetting.setRowColumn(originImages.count)
        }
        if let rows = rows { watermark.arraySetting.rows = rows }
        if let columns = columns { watermark.arraySetting.columns = columns }
    }
}

