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
import PlatformCore
import WatermarkDomain
import PlatformExport
import RenderEngine

public class WatermarkEditViewModel: ObservableObject {
    enum Action {
        case open(_ type: WatermarkEditPickerType)
        case picker
        case menu
        case update(_ update: Update)
        case preview
        case word(_ text: String)
        case popup(_ route: WatermarkPopupRoute?)
    }
    
    enum Update {
        case onDate
        case onGradient
        case setColor(color: Color)
    }
    
    @Published var origins: [PImage] = []
    
    // MARK: - Picker
    @Published var isShowPicker: Bool = false
    @Published var pickerType: WatermarkEditPickerType?
    @Published var page: Int = 0
    
    // MARK: - Watermark Word
    @Published var words: [String] = []
    
    // MARK: - Category
    @Published var isShowMenu: Bool = false
    @Published var indexCategory: Int = 0
    @Published var menuHeight: CGFloat = .zero
    
    let colorPalet: [Color] = [.white, .Gray.medium, .black, .Yejun.main, .Noah.main, .Bamby.main, .Eunho.main, .Hamin.main]
    @Published var sticker = WatermarkEditListViewState()
    @Published var frame = WatermarkEditListViewState()
    
    // MARK: - Watermark
    var store: WatermarkStore
    
    let popup: WatermarkPopupCoordinator
    let usecase: WatermarkUsecase
    let picker: AssetPicker
    let stickerPicker: AssetPicker
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        popup: WatermarkPopupCoordinator,
        usecase: WatermarkUsecase,
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore
    ) {
        self.popup = popup
        self.usecase = usecase
        self.picker = picker
        self.stickerPicker = stickerPicker
        self.store = store
        words = usecase.fetchWords().map { $0.text }
        
        var new = WatermarkModel()
        new.text.text = (words.first ?? "PLAVE") + (new.text.isDate ? "\(Date.now)" : "")
        self.store.setWatermark(new)
        
        bind()
    }
}

private extension WatermarkEditViewModel {
    func bind() {
        store.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        picker.$assets
                .map { $0.compactMap(\.imageAsset) }
                .sink { [weak self] assets in
                    self?.origins = assets
                    self?.initialize()
                }
                .store(in: &cancellables)
    }
    
    func initialize() {
        if let asset = origins.first {
            let ratio = asset.size.width / 650
            let fontSize = ratio * 36
            let spacing = ratio * 20
            store.watermark.text.rotation = -30
            store.watermark.text.fontName = FontType.body1.fontName
            store.watermark.text.fontSize = fontSize
            store.watermark.text.spacingWidth = spacing
            store.watermark.text.spacingHeight = spacing
        }
        if let color = colorPalet.first {
            store.watermark.text.color = ColorData(color)
        }
    }
}

@MainActor
extension WatermarkEditViewModel {
    func action(_ action: Action) {
        switch action {
        case .open(let type):
            open(type)
        case .picker:
            actionPicker()
        case .menu:
            menu()
        case .update(let action):
            update(action)
        case .preview:
            makePreview()
        case .word(let text):
            word(text)
        case .popup(let route):
            popup(route)
        }
    }
}

private extension WatermarkEditViewModel {
    func open(_ type: WatermarkEditPickerType) {
        isShowPicker = true
        pickerType = type
    }
    
    func actionPicker() {
        switch pickerType {
        case .picture:
            let assets = picker.assets
            origins = assets.compactMap { $0.imageAsset }
        case .sticker:
            let assets = stickerPicker.assets
            sticker.images = assets.compactMap { $0.imageAsset }
            sticker.list = sticker.images.map { .init(image: $0) }
        case .none:
            break
        }
        pickerType = nil
    }
    
    func menu() {
        withAnimation {
            isShowMenu.toggle()
        }
    }
    
    func update(_ update: Update) {
        switch update {
        case .onDate:
            store.watermark.text.isDate.toggle()
        case .onGradient:
            store.watermark.text.isGradient.toggle()
        case .setColor(let color):
            store.watermark.text.color = ColorData(color)
        }
    }
    
    func makePreview() {
        
    }
    
    func word(_ text: String) {
        store.watermark.text.text = text
    }
    
    func popup(_ route: WatermarkPopupRoute?) {
        if let route = route {
            popup.push(route: route)
        } else {
            popup.popRoot()
        }
    }
}
/*

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
*/
