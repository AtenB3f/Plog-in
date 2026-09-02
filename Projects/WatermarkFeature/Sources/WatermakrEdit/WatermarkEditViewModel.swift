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
import CoreDomain
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
    
    let colorPalet: [Color] = [.white, .Gray.medium, .black, .Yejun.main, .Noah.main, .Bamby.main, .Eunho.main, .Hamin.main]
    
    // MARK: - Picker
    @Published var isShowPicker: Bool = false
    @Published var pickerType: WatermarkEditPickerType?
    
    // MARK: - Watermark Word
    @Published var words: [String] = []
    
    // MARK: - Category
    @Published var isShowMenu: Bool = false
    @Published var indexCategory: Int = 0
    @Published var menuHeight: CGFloat = .zero
    
    @Published var stickerState: FrameListState = FrameListState()
    
    @Published var isShowArrayType = false
    @Published var arrayState: FrameListState = FrameListState()
    
    @Published var isShowExportType = false
    
    @Published var frameState: FrameListState = FrameListState()
    @Published var frames: [WatermarkModel] = []
    @Published var currentFrameUUID: UUID?
    
    private var isNewWatermark: Bool
    private var savedSnapshot: WatermarkModel?
    var hasUnsavedChanges: Bool {
        guard let savedSnapshot else { return true }
        return savedSnapshot != store.watermark
    }

    // MARK: - Watermark
    var store: WatermarkStore
    let editMode: WatermarkEditModeStore
    private let popup: WatermarkPopupCoordinator
    private let usecase: WatermarkUsecase
    private let format: WatermarkFormat
    let picker: AssetPicker
    let sticker: AssetPicker
    private let crashReport: CrashReport?

    private var cancellables = Set<AnyCancellable>()

    // Watermark Flow Step
    private let stepSubject = PassthroughSubject<WatermarkFlowStep, Never>()
    public var step: AnyPublisher<WatermarkFlowStep, Never> { stepSubject.eraseToAnyPublisher() }

    public init(
        watermark: WatermarkModel? = nil,
        popup: WatermarkPopupCoordinator,
        usecase: WatermarkUsecase,
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore,
        editMode: WatermarkEditModeStore,
        format: WatermarkFormat = WatermarkFormat(),
        crashReport: CrashReport? = nil
    ) {
        self.popup = popup
        self.usecase = usecase
        self.format = format
        self.picker = picker
        self.sticker = stickerPicker
        self.store = store
        self.editMode = editMode
        self.crashReport = crashReport
        words = usecase.fetchWords().map { $0.text }
        frames = usecase.fetchWatermarks()

        if let watermark = watermark {
            self.store.setWatermark(watermark)
            self.savedSnapshot = watermark
            self.isNewWatermark = false
        } else {
            self.store.setWatermark(WatermarkModel())
            self.savedSnapshot = nil
            self.isNewWatermark = true
        }

        bind()
    }
}

// MARK: - Initialize
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
        
        popup.step
            .sink { [weak self] step in
                self?.handlePopupComplete(step)
            }
            .store(in: &cancellables)

        // edit mode: sticker 선택 인덱스
        $stickerState
            .map(\.index)
            .removeDuplicates()
            .sink { [weak self] index in
                self?.editMode.selectSticker(index)
            }
            .store(in: &cancellables)

        // edit mode
        editMode.$mode
            .map(\.stickerIndex)
            .removeDuplicates()
            .sink { [weak self] index in
                guard let self, stickerState.index != index else { return }
                stickerState.index = index
                if index != nil {
                    if stickerState.mode == .none { stickerState.mode = .select }
                } else if stickerState.mode == .select {
                    stickerState.mode = .none
                }
            }
            .store(in: &cancellables)
    }

    func originInit() {
        if !picker.images.isEmpty {
            store.watermark.array.setRowColumn(picker.images.count)
            usecase.setupWatermark(
                isUpdateText: isNewWatermark,
                origins: picker.images,
                current: &store.watermark
            )
            store.watermark.text.fontName = FontType.body1.fontName
        }
        if let color = colorPalet.first, isNewWatermark {
            store.watermark.text.color = ColorData(color, alpha: store.watermark.text.color.opacity)
        }
        words = usecase.fetchWords().map { $0.text }
    }

    func stickerInit() {
        guard !picker.images.isEmpty else { return }
        let models = format.makeStickerModels(
            stickers: sticker.images,
            origins: picker.images,
            array: store.watermark.array
        )
        store.setSticker(store.watermark.stickers + models)
        sticker.images = []
    }
}

// MARK: - Action
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

// MARK: - Export Size Display
extension WatermarkEditViewModel {
    /// 실제 저장될 사이즈를 계산하여 출력 메뉴에 표기
    func exportSizeStr(currentImageIndex: Int) -> String {
        guard store.watermark.array.type == .none,
              picker.images.indices.contains(currentImageIndex)
        else {
            return store.watermark.export.getSizeStr()
        }
        let size = format.getExportSize(for: picker.images[currentImageIndex], export: store.watermark.export)
        return WatermarkExportModel(width: size.width, height: size.height).getSizeStr()
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
    }
    
    func makePreview() {
        stepSubject.send(.editFinished(watermark: store.watermark, origins: picker.images))
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
            arrayState.index = nil
            arrayState.mode = .none
            picker.images = []
        case .sticker:
            stickerState.index = nil
            stickerState.mode = .none
            store.watermark.stickers = []
        default:
            break
        }
    }

    func removeAt(_ type: WatermarkMenuType, _ index: Int) {
        switch type {
        case .array:
            guard index < picker.images.count else { return }
            if arrayState.index == index {
                arrayState.index = nil
            } else if let selected = arrayState.index, selected > index {
                arrayState.index = selected - 1
            }
            picker.images.remove(at: index)
        case .sticker:
            guard index < store.watermark.stickers.count else { return }
            if stickerState.index == index {
                stickerState.index = nil
            } else if let selected = stickerState.index, selected > index {
                stickerState.index = selected - 1
            }
            store.watermark.stickers.remove(at: index)
        case .frame:
            guard index < frames.count else { return }
            if frameState.index == index {
                frameState.index = nil
            } else if let selected = frameState.index, selected > index {
                frameState.index = selected - 1
            }
            frames.remove(at: index)
        default:
            break
        }
    }
    
    func move(_ type: WatermarkMenuType, _ from: IndexSet, _ to: Int) {
        switch type {
        case .array:
            picker.images.move(fromOffsets: from, toOffset: to)
        case .sticker:
            if let selected = stickerState.index {
                var indices = Array(store.watermark.stickers.indices)
                indices.move(fromOffsets: from, toOffset: to)
                stickerState.index = indices.firstIndex(of: selected)
            }
            store.watermark.stickers.move(fromOffsets: from, toOffset: to)
        case .frame:
            frames.move(fromOffsets: from, toOffset: to)
        default:
            break
        }
    }
    
    func replicate(_ type: WatermarkMenuType) {
        switch type {
        case .sticker:
            guard let index = stickerState.index else { return }
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
    
    func handlePopupComplete(_ step: WatermarkPopupFlowStep) {
        switch step {
        case .dismiss:
            popup.pop()
        case .wordStart:
            popup.push(route: .word)
        case .wordFinished(let text):
            words = usecase.fetchWords().map { $0.text }
            word(text)
            popup.pop()
        case .titleFinished(let title):
            store.watermark.frame.title = title
            if let index = frames.firstIndex(where: { $0.id == store.watermark.id }) {
                frames[index].frame.title = title
            }
            popup.pop()
        case .previewFinished:
            // save preview
            popup.pop()
        }
    }
}

private extension WatermarkEditViewModel {
    func setText(_ menu: WatermarkEditMenuType.TextMenu) {
        switch menu {
        case .word(let text):
            word(text)
        case .color(let color):
            let alpha = store.watermark.text.color.opacity
            store.watermark.text.color = ColorData(color, alpha: alpha)
        case .date:
            if store.watermark.text.date == nil {
                store.watermark.text.date = Date()
            } else {
                store.watermark.text.date = nil
            }
        case .gradient:
            if store.watermark.text.gradientColors.isEmpty {
                store.watermark.text.gradientColors = Color.disablePrimarys.map { ColorData($0, alpha: 0.3) }
            } else {
                store.watermark.text.gradientColors = []
            }
        }
    }
    
    func setSticker(_ menu: WatermarkEditMenuType.StickerMenu) {
    }
    
    func setArray(_ menu: WatermarkEditMenuType.ArrayMenu) {
        switch menu {
        case .toggle:
            isShowArrayType.toggle()
        case .type(let type):
            let oldWidth = format.getWatermarkImageSize(
                origins: picker.images,
                array: store.watermark.array
            ).width

            store.setArray(format.makeArrayModel(
                origins: picker.images,
                type: type,
                current: store.watermark.array
            ))
            
            let exportType = store.watermark.export.type
            store.setExport(format.makeExportModel(
                origins: picker.images,
                array: store.watermark.array
            ))
            store.watermark.export.type = exportType
            format.makeTextModel(
                origins: picker.images,
                array: store.watermark.array,
                current: &store.watermark.text
            )

            let newWidth = format.getWatermarkImageSize(
                origins: picker.images,
                array: store.watermark.array
            ).width
            if !store.watermark.stickers.isEmpty {
                store.setSticker(
                    format.rescaleStickers(
                        store.watermark.stickers,
                        oldWidth: oldWidth,
                        newWidth: newWidth
                    )
                )
            }
        case .order:
            break
        }
    }

    func setExport(_ menu: WatermarkEditMenuType.ExportMenu) {
        switch menu {
        case .type(let type): // 타입 전환
            switch type {
            case .auto:
                var export = format.makeExportModel(
                    origins: picker.images,
                    array: store.watermark.array
                )
                export.multiple = store.watermark.export.multiple
                store.setExport(export)
            case .multiple:
                store.setExport(format.makeExportModel(
                    origins: picker.images,
                    array: store.watermark.array,
                    multiple: store.watermark.export.multiple
                ))
            }
        case .multiple: // 배율 조정
            guard store.watermark.export.type == .multiple else { return }
            store.setExport(format.makeExportModel(
                origins: picker.images,
                array: store.watermark.array,
                multiple: store.watermark.export.multiple
            ))
        }
    }
    
    func setFrame(_ menu: WatermarkEditMenuType.FrameMenu) {
        switch menu {
        case .load:
            guard let index = frameState.index, index < frames.count else { return }
            store.watermark.text = frames[index].text
            store.watermark.stickers = frames[index].stickers
            store.watermark.array = frames[index].array
            store.watermark.export = frames[index].export
            store.watermark.frame = frames[index].frame
            
            setArray(.type(store.watermark.array.type))
            setExport(.type(store.watermark.export.type))
        case .save:
            if !picker.images.isEmpty {
                let editor = WatermarkEditor(
                    watermark: store.watermark,
                    origins: picker.images,
                    crashReport: crashReport
                )
                store.watermark.frame.thumbnailData = editor.generateThumbnail().pngData()
            }
            usecase.saveWatermark(store.watermark)
            savedSnapshot = store.watermark
            currentFrameUUID = store.watermark.id
            frames = usecase.fetchWatermarks()

        case .title:
            popup(.title)
        }
    }
}
