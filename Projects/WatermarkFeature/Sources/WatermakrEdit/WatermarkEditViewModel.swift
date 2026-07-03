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
        case remove(_ type: WatermarkMenuType)
        case removeAt(_ type: WatermarkMenuType, _ index: Int)
        case move(_ type: WatermarkMenuType, _ from: IndexSet, _ to: Int)
        case replicate(_ type: WatermarkMenuType)
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
    
    @Published var isShowArrayType = false
    @Published var arrayMode: FrameListMode = .none
    @Published var arraySelect: Int?
    @Published var stickerMode: FrameListMode = .none
    @Published var stickerSelect: Int?
    @Published var isShowExportType = false
    @Published var frame = WatermarkListViewState()
    
    // MARK: - Watermark
    var store: WatermarkStore
    let popup: WatermarkPopupCoordinator
    let usecase: WatermarkUsecase
    let picker: AssetPicker
    let sticker: AssetPicker
    
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
        self.sticker = stickerPicker
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

        picker.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        sticker.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        popup.$history
            .sink { [weak self] history in
                guard let self = self else { return }
                self.handlePopupComplete(history)
            }
            .store(in: &cancellables)
    }
    
    func originInit() {
        if !picker.images.isEmpty {
            store.watermark.export = usecase.makeExportModel(
                origins: picker.images,
                array: store.watermark.array
            )
            store.watermark.text.fontName = FontType.body1.fontName
            store.watermark.text.rotation = -30
            store.watermark.text = usecase.makeTextModel(
                export: store.watermark.export,
                current: store.watermark.text
            )
        }
        if let color = colorPalet.first {
            store.watermark.text.color = ColorData(color)
        }
        words = usecase.fetchWords().map { $0.text }
    }

    func stickerInit() {
        guard let origin = picker.images.first else { return }
        let models = usecase.makeStickerModels(
            stickers: sticker.images,
            origin: origin
        )
        store.setSticker(models)
        sticker.images = []
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
        case .remove(let type):
            remove(type)
        case .removeAt(let type, let index):
            removeAt(type, index)
        case .move(let type, let from, let to):
            move(type, from, to)
        case .replicate(let type):
            replicate(type)
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
            originInit()
        case .sticker:
            stickerInit()
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
    
    func remove(_ type: WatermarkMenuType) {
        switch type {
        case .array:
            arraySelect = nil
            arrayMode = .none
            picker.images = []
        case .sticker:
            stickerSelect = nil
            stickerMode = .none
            store.watermark.stickers = []
        default:
            break
        }
    }

    func removeAt(_ type: WatermarkMenuType, _ index: Int) {
        switch type {
        case .array:
            guard index < picker.images.count else { return }
            if arraySelect == index {
                arraySelect = nil
            } else if let selected = arraySelect, selected > index {
                arraySelect = selected - 1
            }
            picker.images.remove(at: index)
        case .sticker:
            guard index < store.watermark.stickers.count else { return }
            if stickerSelect == index {
                stickerSelect = nil
            } else if let selected = stickerSelect, selected > index {
                stickerSelect = selected - 1
            }
            store.watermark.stickers.remove(at: index)
        default:
            break
        }
    }
    
    func move(_ type: WatermarkMenuType, _ from: IndexSet, _ to: Int) {
        switch type {
        case .array:
            picker.images.move(fromOffsets: from, toOffset: to)
        case .sticker:
            store.watermark.stickers.move(fromOffsets: from, toOffset: to)
        default:
            break
        }
    }
    
    func replicate(_ type: WatermarkMenuType) {
        switch type {
        case .sticker:
            guard let index = stickerSelect else { return }
            guard store.watermark.stickers.count <= 10 else { return }
            var model = store.watermark.stickers[index]
            model.layer = store.watermark.stickers.count
            store.watermark.stickers.append(model)
        case .frame:
            break
        default:
            break
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
            store.watermark.array.setRowColumn(picker.images.count)
            let exportType = store.watermark.export.type
            store.watermark.export = usecase.makeExportModel(
                origins: picker.images,
                array: store.watermark.array
            )
            store.watermark.export.type = exportType
            updateTextForExport()
        case .order:
            break
        }
    }

    func setExport(_ menu: WatermarkEditMenuType.ExportMenu) {
        switch menu {
        case .type(let type): // 타입 전환
            switch type {
            case .auto:
                var export = usecase.makeExportModel(
                    origins: picker.images,
                    array: store.watermark.array
                )
                export.multiple = store.watermark.export.multiple
                store.watermark.export = export
            case .multifple:
                store.watermark.export = usecase.makeExportModel(
                    origins: picker.images,
                    array: store.watermark.array,
                    multiple: store.watermark.export.multiple
                )
            }
            updateTextForExport()
        case .multiple: // 배율 조정
            guard store.watermark.export.type == .multifple else { return }
            store.watermark.export = usecase.makeExportModel(
                origins: picker.images,
                array: store.watermark.array,
                multiple: store.watermark.export.multiple
            )
            updateTextForExport()
        }
    }

    func updateTextForExport() {
        store.watermark.text = usecase.makeTextModel(
            export: store.watermark.export,
            current: store.watermark.text
        )
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

