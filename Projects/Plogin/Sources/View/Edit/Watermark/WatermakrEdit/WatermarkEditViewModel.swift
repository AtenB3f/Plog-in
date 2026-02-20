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
//    @Published var watermark: WatermarkModel = WatermarkModel() {
//        didSet {
//            makePreview()
//        }
//    }
    
    // MARK: - Category
    @Published var isShowMenu: Bool = false
    @Published var indexCategory: Int = 0
    @Published var menuHeight: CGFloat = .zero
    
    // MARK: - Category Text
    @Published var textColor: Color = .white
    
    // MARK: - Category Sticker
//    @Published var stickerAsset: [AssetData] = [] {
//        didSet {
//            self.stickers = stickerAsset.compactMap { $0.imageAsset }
//            self.stickerList = stickers.map { .init(image: $0) }
//            for index in stickers.indices {
//                self.watermark.stickers.removeAll()
//                self.watermark.stickers.append(.init(
//                    image: stickers[index],
//                    alpha: 0.5,
//                    position: .zero,
//                    rotation: -30,
//                    scale: 0.5,
//                    layer: index
//                ))
//            }
//        }
//    }
//    @Published var stickers: [PImage] = []
    @Published var stickerListMode: FrameListMode = .none
    @Published var stickerList: [WatermarkStickerItemModel] = []
//    @Published var stickerSelect: Int?
    
    // MARK: - Category Array
    @Published var isShowArrayType: Bool = false
//    {
//        didSet { isShowGrid = isShowArrayType && watermark.arraySetting.type == .grid }
//    }
    @Published var isShowGrid: Bool = false
    @Published var arrayType: WatermarkArrayType = .none
//    @Published var grid = GridValue()
    
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
    @Published var frames: [WatermarkModel] = []
//    {
//        didSet {
//            frameList = frames.map { WatermarkFrameItemModel(image: $0.frameSetting.thumbnail , title: $0.frameSetting.title) }
//        }
//    }
    @Published var frameList: [WatermarkFrameItemModel] = []
    @Published var frameSelect: Int?
    var frameTitle: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        words = dataManager.loadWatermarkWord().map { $0.text }
//        textColor = watermark.textSetting.color.toUI
//        arrayType = watermark.arraySetting.type
        frames = dataManager.loadWatermark()
    }
    
    
}

// MARK: - Binding
extension WatermarkEditViewModel {
    func setText(
        watermark: WatermarkModel,
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
//        makePreview()
    }
    
    func setSticker(
        watermark: WatermarkModel,
        _ stickers: [WatermarkStickerModel]
    ) {
        watermark.stickers = stickers
//        makePreview()
    }
    
    func setSticker(
        watermark: WatermarkModel,
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
//        makePreview()
    }
    
    func setArray(
        watermark: WatermarkModel,
        type: WatermarkArrayType? = nil,
        rows: Int? = nil,
        columns: Int? = nil
    ) {
        isShowGrid = isShowArrayType && type == .grid
//        calculateSize()
//        makePreview()
    }
    
    func setExport(
        watermark: WatermarkModel,
        type: WatermarkExportType? = nil,
        size: CGSize? = nil
    ) {
        let newValue = watermark.exportSetting
        if let type = type { newValue.type = type }
        if let size = size { newValue.width = size.width; newValue.height = size.height }
        
        isShowExportSlider = type == .multifple
        if type == .auto { newValue.multiple = 1.0 }
        
        watermark.exportSetting = newValue
//        calculateSize()
//        makePreview()
    }
    
    func setFrame(
        watermark: WatermarkModel
    ) {
//        self.watermark = watermark
    }
}

extension WatermarkEditViewModel {
}

extension WatermarkEditViewModel {
    func pushPicker(_ type: PickerType?) {
        isShowPicker = type != nil
        pickerType = type
    }
}

extension WatermarkEditViewModel {
    func saveWatermarkWord(watermark: WatermarkModel) {
        setText(watermark: watermark, text: self.newWord)
        dataManager.saveWatermarkWord(self.newWord)
        words = dataManager.loadWatermarkWord().map { $0.text }
    }
}

extension WatermarkEditViewModel {
    func loadImages() {
        images = assets.compactMap { $0.imageAsset }
        arrayItems = images.map { .init(image: $0) }
    }
    
//    func makePreview() {
//        previews = editor.generateWatermarks(images, watermark: watermark)
//    }
    
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
    
//    func saveWatermarkFrame() {
//        dataManager.saveWatermark(watermark)
//        frames = dataManager.loadWatermark()
//    }
}
