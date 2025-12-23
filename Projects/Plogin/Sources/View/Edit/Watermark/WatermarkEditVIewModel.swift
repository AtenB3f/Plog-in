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

struct GridValue: Equatable {
    var row: Int = 1
    var colums: Int = 1
}

enum PickerType {
    case watermark
    case sticker
    
    var maxCount: Int {
        switch self {
        case .watermark:
            return 30
        case .sticker:
            return 10
        }
    }
    var mediaType: MediaType {
        return .image
    }
}

class WatermarkEditViewModel: ObservableObject {
    private let dataManager = DataStore.shared
    private let manager = AppManager.shared
    let editor = WatermarkManager()
    
    @Published var isShowPicker: Bool = false
    @Published var pickerType: PickerType?
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
    @Published var menuHeight: CGFloat = .zero
    
    // MARK: - Category Text
    @Published var textColor: Color = .white
    
    // MARK: - Category Sticker
    @Published var stickerAsset: [AssetData] = [] {
        didSet {
            self.stickers = stickerAsset.compactMap { $0.imageAsset }
            self.stickerList = stickers.map { .init(image: $0) }
            for index in stickers.indices {
                self.watermark.stickers.removeAll()
                self.watermark.stickers.append(.init(
                    image: stickers[index],
                    alpha: 0.5,
                    position: .zero,
                    rotation: -30,
                    scale: 0.5,
                    layer: index
                ))
            }
        }
    }
    @Published var stickers: [PImage] = []
    @Published var stickerListMode: FrameListMode = .none
    @Published var stickerList: [WatermarkStickerItemModel] = []
    @Published var stickerSelect: Int?
    
    // MARK: - Category Array
    @Published var isShowArrayType: Bool = false {
        didSet { isShowGrid = isShowArrayType && watermark.arraySetting.type == .grid }
    }
    @Published var isShowGrid: Bool = false
    @Published var arrayType: WatermarkArrayType = .none
    @Published var grid = GridValue()
    
    @Published var arrayItems: [WatermarkArrayItemModel] = [] {
        didSet {
            images = arrayItems.compactMap { $0.image }
        }
    }
    
    // MARK: - Category Export
    @Published var isShowExport: Bool = false
    @Published var isShowExportSlider: Bool = false
    
    // MARK: - Category Frame
    @Published var frameListMode: FrameListMode = .none
    @Published var setFrame = WatermarkFrameModel()
    @Published var frames: [WatermarkModel] = [] {
        didSet {
            frameList = frames.map { WatermarkFrameItemModel(image: $0.frameSetting.thumbnail , title: $0.frameSetting.title) }
        }
    }
    @Published var frameList: [WatermarkFrameItemModel] = []
    @Published var frameSelect: Int?
    var frameTitle: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        words = dataManager.loadWatermarkWord().map { $0.text }
        watermark.textSetting.text = words.first ?? ""
        textColor = watermark.textSetting.color.toUI
        arrayType = watermark.arraySetting.type
        frames = dataManager.loadWatermark()
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
    
    func setSticker(_ stickers: [WatermarkStickerModel]) {
        watermark.stickers = stickers
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
        guard index >= 0 && index < watermark.stickers.count else { return }
        let newValue = watermark.stickers[index]
        if let image = image { newValue.imageData = image.pngData() }
        if let alpha = alpha { newValue.alpha = alpha }
        if let position = position { newValue.position = position }
        if let rotation = rotation { newValue.rotation = rotation }
        if let scale = scale { newValue.scale = scale }
        if let layer = layer { newValue.layer = layer }
        
        watermark.stickers[index] = newValue
        makePreview()
    }
    
    func setArray(
        type: WatermarkArrayType? = nil,
        rows: Int? = nil,
        columns: Int? = nil
    ) {
        let newValue = watermark.arraySetting
        if let type = type {
            arrayType = type
            newValue.type = type
            switch type {
            case .horizontal:
                newValue.rows = 1
                newValue.columns = images.count
            case .vertical:
                newValue.rows = images.count
                newValue.columns = 1
            default:
                newValue.rows = 1
                    newValue.columns = 1
            }
        }
        if let rows = rows { newValue.rows = rows }
        if let columns = columns { newValue.columns = columns }
        
        watermark.arraySetting = newValue
        isShowGrid = isShowArrayType && newValue.type == .grid
        calculateSize()
        makePreview()
    }
    
    func setExport(
        type: WatermarkExportType? = nil,
        size: CGSize? = nil
    ) {
        let newValue = watermark.exportSetting
        if let type = type { newValue.type = type }
        if let size = size { newValue.width = size.width; newValue.height = size.height }
        
        isShowExportSlider = type == .multifple
        if type == .auto { newValue.multiple = 1.0 }
        
        watermark.exportSetting = newValue
        calculateSize()
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
    
    func calculateSticker() {
        
    }
    
    func calculateSize() {
        guard let firstImage = images.first else { return }
        guard let maxRatio = images.map({ $0.size.height / $0.size.width }).max() else { return }
        let multiple: CGFloat = watermark.exportSetting.multiple
        let originCellSize: CGSize = .init(width: firstImage.size.width, height: firstImage.size.width * maxRatio)
        switch watermark.arraySetting.type {
        case .none:
            watermark.exportSetting.width = firstImage.size.width * multiple
            watermark.exportSetting.height = firstImage.size.height * multiple
        case .horizontal:
            let width = originCellSize.width * CGFloat(watermark.arraySetting.columns)
            let height = originCellSize.height
            if 3600 > width {
                watermark.exportSetting.width = width * multiple
                watermark.exportSetting.height = height * multiple
            } else {
                watermark.exportSetting.width = 3600 * multiple
                watermark.exportSetting.height = height * (3600/width) * multiple
            }
        case .vertical:
            let width = originCellSize.width
            let height = originCellSize.height * CGFloat(watermark.arraySetting.rows)
            if 3600 > height {
                watermark.exportSetting.width = width * multiple
                watermark.exportSetting.height = height * multiple
            } else {
                watermark.exportSetting.width =  width * (3600/height) * multiple
                watermark.exportSetting.height = 3600 * multiple
            }
        case .grid:
            let width = originCellSize.width * CGFloat(watermark.arraySetting.columns)
            let height = originCellSize.height * CGFloat(watermark.arraySetting.rows)
            if width > height || maxRatio < 1 {
                if 3600 > width {
                    watermark.exportSetting.width = width * multiple
                    watermark.exportSetting.height = height * multiple
                } else {
                    watermark.exportSetting.width = 3600 * multiple
                    watermark.exportSetting.height = height * (3600/width) * multiple
                }
            } else {
                if 3600 > height {
                    watermark.exportSetting.width = width * multiple
                    watermark.exportSetting.height = height * multiple
                } else {
                    watermark.exportSetting.width =  width * (3600/height) * multiple
                    watermark.exportSetting.height = 3600 * multiple
                }
            }
        }
    }
}

extension WatermarkEditViewModel {
    func pushPicker(_ type: PickerType?) {
        isShowPicker = type != nil
        pickerType = type
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
        arrayItems = images.map { .init(image: $0) }
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
    
    func saveWatermarkFrame() {
        dataManager.saveWatermark(watermark)
        frames = dataManager.loadWatermark()
    }
}
