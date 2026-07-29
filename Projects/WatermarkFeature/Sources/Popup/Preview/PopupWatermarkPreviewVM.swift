//
//  PopupWatermarkPreviewVM.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import Design
import UISchema
import WatermarkDomain
import PlatformCore

public class PopupWatermarkPreviewVM: PopupViewModel {
    enum Action {
        case input
        case save
        case clear
        case cancel
        case confirm
    }
    
    @Published var assets: [AssetData] = []
    @Published var words: [String] = []
    @Published var text: String = ""
    @Published var isShowInput: Bool = false
    @Published var preview: Image?
    var previewData: PImage? {
        didSet {
            guard let previewData = previewData else { return }
            preview = Image(uiImage: previewData)
        }
    }
    
    var usecase: WatermarkUsecase
    
    // Watermark Popup Flow Step
    private let stepSubject = PassthroughSubject<WatermarkPopupFlowStep, Never>()
    public var step: AnyPublisher<WatermarkPopupFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    public init(
        usecase: WatermarkUsecase
    ) {
        self.usecase = usecase
        super.init()
        self.loadWords()
    }
}

@MainActor
extension PopupWatermarkPreviewVM {
    func action(_ action: Action) {
        switch action {
        case .input:
            input()
        case .save:
            save()
        case .clear:
            clear()
        case .cancel:
            cancel()
        case .confirm:
            confirm()
        }
    }
}

@MainActor
extension PopupWatermarkPreviewVM {
    func input() {
//        dataManager.saveWatermarkWord(text)
//            isShowInput = false
    }
    
    func save() {
//        dataManager.saveWatermarkWord(text)
//        text = dataManager.loadWatermarkWord().first?.text ?? ""
    }
    
    func clear() {
        text = ""
    }
    
    func cancel() {
        // popup dismiss
//        coordinator.pop()
        stepSubject.send(.previewFinished)
    }
    
    func confirm() {
        // data save
        
        stepSubject.send(.previewFinished)
    }
}

extension PopupWatermarkPreviewVM {
    func loadWords() {
//        self.words = dataManager.loadWatermarkWord().map { $0.text }
        self.words = []
    }
    
    func makePreview(_ watermark: WatermarkModel) {
        guard let image = assets.first?.imageAsset else { return }
//        watermark.textSetting.text = text
//        previewData = editer.drawWatermark(image: image, watermark: watermark)
    }    
}
