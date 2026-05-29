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
        case update(_ type: WatermarkEditMenuType)
        case preview
        case word(_ text: String)
        case popup(_ route: WatermarkPopupRoute?)
    }
    
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
    
    @Published var sticker = WatermarkListViewState()
    @Published var isShowArrayType = false
    @Published var array: [WatermarkItem] = []
    @Published var isShowExportType = false
    @Published var frame = WatermarkListViewState()
    
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
        new.text.text = (words.first ?? "PLAVE")
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
                    self?.array = assets.compactMap { .init(image: $0) }
                    self?.initialize()
                }
                .store(in: &cancellables)
        
        popup.$history
            .sink { [weak self] history in
                guard let self = self else { return }
                self.handlePopupComplete(history)
            }
            .store(in: &cancellables)
        
        $array
            .sink { [weak self] list in
                guard let self = self else { return }
                // TODO: picker에 채워넣기..?
            }
            .store(in: &cancellables)
    }
    
    func initialize() {
        if let asset = array.first?.image {
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
        words = usecase.fetchWords().map { $0.text }
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
            array = assets.compactMap { $0.imageAsset }.map { .init(image: $0) }
        case .sticker:
            let assets = stickerPicker.assets
            sticker.list = assets.compactMap { $0.imageAsset }.map { .init(image: $0) }
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
    
    func update(_ type: WatermarkEditMenuType) {
        switch type {
        case .text(let menu):
            setText(menu)
        case .sticker(let menu):
            setSticker(menu)
        case .array(let menu):
            setArray(menu)
        case .export(let menu):
            setExport(menu)
        case .frame(let menu):
            setFrame(menu)
        }
//        switch update {
//        case .onDate:
//            store.watermark.text.isDate.toggle()
//        case .onGradient:
//            store.watermark.text.isGradient.toggle()
//        case .setColor(let color):
//            store.watermark.text.color = ColorData(color)
//        }
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
    
    func handlePopupComplete(_ route: WatermarkPopupRoute?) {
        guard let route = route else { return }
        switch route {
        case .word:
            words = usecase.fetchWords().map { $0.text }
        case .title:
            break
        case .preview:
            break
        }
    }
}

private extension WatermarkEditViewModel {
    func setText(_ menu: WatermarkEditMenuType.TextMenu) {
        switch menu {
        case .word(let text):
            store.watermark.text.text = text
        case .color(let color):
            let alpha = store.watermark.text.color.opacity
            store.watermark.text.color = ColorData(color, alpha: alpha)
        case .date:
            store.watermark.text.date = Date()
        case .gradient:
            store.watermark.text.isGradient.toggle()
        }
    }
    
    func setSticker(_ menu: WatermarkEditMenuType.StickerMenu) {
//        switch menu {
//        case .load:
//            
//        case .edit:
//            
//        case .remove:
//            
//        }
    }
    
    func setArray(_ menu: WatermarkEditMenuType.ArrayMenu) {
        switch menu {
        case .toggle:
            isShowArrayType.toggle()
        case .type(let type):
            store.watermark.array.type = type
            store.watermark.array.setRowColumn(array.count)
        case .order:
            break
        }
    }
    
    func setExport(_ menu: WatermarkEditMenuType.ExportMenu) {
        switch menu {
        case .type(let type):
            store.watermark.export.type = type
        }
    }
    
    func setFrame(_ menu: WatermarkEditMenuType.FrameMenu) {
//        switch menu {
//        case .save:
//            
//        case .title:
//            
//        }
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
