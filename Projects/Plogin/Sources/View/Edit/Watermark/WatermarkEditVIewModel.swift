//
//  WatermarkEditViewModel.swift
//  Plogin
//
//  Created by AtenB on 8/13/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design
import Combine

class WatermarkEditViewModel: ObservableObject {
    private let dataManager = DataStore.shared
    let editor = ImageEditManager()
    
    @Published var isShowPicker: Bool = false
    @Published var page: Int = 0
    
    @Published var assets: [AssetData] = [] {
        didSet {
            loadImages()
        }
    }
    var images: [PImage] = []
    @Published var previews: [PImage] = []
    
    // MARK: - Watermark Text
    @Published var words: [String] = []
    @Published var newWord: String = ""
    
    // MARK: - Watermark
    @Published var watermark: WatermarkModel = WatermarkModel() {
        didSet {
            makePreview()
        }
    }
    
    // MARK: - Category
    @Published var isShowMenu: Bool = false
    @Published var indexCategory: Int = 0 
    
    // MARK: - Category Text
    @Published var textColor: Color = .white
    
    // MARK: - Category Sticker
    // MARK: - Category Array
    // MARK: - Category Export
    // MARK: - Category Frame
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        words = dataManager.loadWatermarkWord().map { $0.text }
        watermark.textSetting.text = words.first ?? ""
        textColor = watermark.textSetting.color.toUI
    }
}

// MARK: - Binding
extension WatermarkEditViewModel {
    func setText(
        text: String? = nil,
        fontName: String? = nil,
        fontSize: CGFloat? = nil,
        rotation: CGFloat? = nil,
        color: Color? = nil,
        alpha: CGFloat? = nil,
        spacing: CGFloat? = nil,
        isGradient: Bool? = nil,
        isDate: Bool? = nil
    ) {
        var newValue = watermark.textSetting
        if let text = text { newValue.text = text }
        if let fontName = fontName { newValue.fontName = fontName }
        if let fontSize = fontSize { newValue.fontSize = fontSize }
        if let rotation = rotation { newValue.rotation = rotation }
        if let color = color { newValue.color = .init(color, alpha: alpha ?? 1.0) }
        if let spacing = spacing {
            newValue.spacingWidth = spacing
            newValue.spacingHeight = spacing
        }
        if let isGradient = isGradient { newValue.isGradient = isGradient }
        if let isDate = isDate { newValue.isDate = isDate }
        
        watermark.textSetting = newValue
        makePreview()
    }
    
    func setSticker(_ stickers: [WatermarkStikerModel]) {
        watermark.stikers = stickers
        makePreview()
    }
    
    func setSticker(
        index: Int,
        image: PImage? = nil,
        alpha: CGFloat? = nil,
        position: CGPoint? = nil,
        rotation: CGFloat? = nil,
        scale: CGFloat? = nil,
        layer: Int? = nil
    ) {
        guard index >= 0 && index < watermark.stikers.count else { return }
        let newValue = watermark.stikers[index]
        if let image = image { newValue.image = image.pngData() }
        if let alpha = alpha { newValue.alpha = alpha }
        if let position = position { newValue.position = position }
        if let rotation = rotation { newValue.rotation = rotation }
        if let scale = scale { newValue.scale = scale }
        if let layer = layer { newValue.layer = layer }
        
        watermark.stikers[index] = newValue
        makePreview()
    }
    
    func setArray(
        type: WatermarkArrayType? = nil,
        rows: Int? = nil,
        columns: Int? = nil
    ) {
        let newValue = watermark.arraySetting
        if let type = type { newValue.type = type }
        if let rows = rows { newValue.rows = rows }
        if let columns = columns { newValue.columns = columns }
        
        watermark.arraySetting = newValue
        makePreview()
    }
    
    func setExport(
        type: WatermarkExportType? = nil,
        size: CGSize? = nil
    ) {
        let newValue = watermark.exportSetting
        if let type = type { newValue.type = type }
        if let size = size { newValue.width = size.width; newValue.height = size.height }
        
        watermark.exportSetting = newValue
        makePreview()
    }
    
    func setFrame(_ watermark: WatermarkModel) {
        self.watermark = watermark
    }
}

extension WatermarkEditViewModel {
    func autoSetting() {
        
        if watermark.exportSetting.type == .auto {
            switch watermark.arraySetting.type {
            case .none:
                watermark.exportSetting.width = images.first?.size.width ?? 0
                watermark.exportSetting.height = images.first?.size.height ?? 0
            case .horizontal:
                watermark.exportSetting.width = (images.first?.size.width ?? 0) * CGFloat(images.count)
                watermark.exportSetting.height = images.first?.size.height ?? 0
            case .vertical:
                watermark.exportSetting.width = (images.first?.size.width ?? 0)
                watermark.exportSetting.height = (images.first?.size.height ?? 0) * CGFloat(images.count)
            case .grid:
                watermark.exportSetting.width = (images.first?.size.width ?? 0) * CGFloat(watermark.arraySetting.rows)
                watermark.exportSetting.height = (images.first?.size.height ?? 0) * CGFloat(watermark.arraySetting.columns)
            }
        }
        let fontSize = CGFloat(Int(24.0 * watermark.exportSetting.width / 650.0))
        watermark.textSetting.fontSize = fontSize
    }
}

extension WatermarkEditViewModel {
    func saveWatermarkWord() {
        setText(text: self.newWord)
        dataManager.saveWatermarkWord(self.newWord)
        words = dataManager.loadWatermarkWord().map { $0.text }
    }
}

extension WatermarkEditViewModel {
    func loadImages() {
        images = assets.compactMap { $0.imageAsset }
    }
    
    func makePreview() {
        previews = editor.generateWatermarks(images, watermark: watermark)
    }
    
    func saveWatermarkImage() {
        Task.detached {
            for image in self.previews {
                do {
                    try await self.editor.saveImageToPhotoLibrary(image: image)
                } catch {
                    print("에러: \(error)")
                }
            }
        }
    }
}
