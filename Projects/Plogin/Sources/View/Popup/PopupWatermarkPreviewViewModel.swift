//
//  PopupWatermarkPreviewViewModel.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

enum WatermarkShortStep {
    case picker
    case textInput
    case preview
}

class PopupWatermarkPreviewViewModel: ObservableObject {
    private let dataManager = DataStore.shared
    let editer = ImageEditManager()
    
    @Published var assets: [AssetData] = []
    @Published var words: [String] = []
    @Published var text: String = ""
    @Published var step: WatermarkShortStep = .picker
    @Published var isShowInput: Bool = false
    @Published var preview: Image?
    var previewData: PImage?  {
        didSet {
            guard let previewData = previewData else { return }
            preview = Image(uiImage: previewData)
        }
    }
    
    func inputText() {
        dataManager.saveWatermarkWord(text)
        isShowInput = false
    }
    
    func saveText() {
        dataManager.saveWatermarkWord(text)
        text = dataManager.loadWatermarkWord().first?.text ?? ""
        withAnimation {
            step = .preview
        }
    }
    
    func loadWords() -> [String] {
        return dataManager.loadWatermarkWord().map { $0.text }
    }
    
    func makePreview(_ watermark: WatermarkModel) {
        guard let image = assets.first?.imageAsset else { return }
        watermark.textSetting.text = text
        previewData = editer.drawWatermark(image: image, watermark: watermark)
    }
    
    func saveWatermarkImate() {
        guard let preview = previewData else { return }
        Task.detached {
            do {
                try await self.editer.saveImageToPhotoLibrary(image: preview)
            } catch {
                
            }
        }
    }
}
