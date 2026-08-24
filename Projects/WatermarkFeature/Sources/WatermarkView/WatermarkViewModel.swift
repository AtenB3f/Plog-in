//
//  WatermarkViewModel.swift
//  Plogin
//
//  Created by AtenB on 12/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import PlatformCore
import PlatformExport
import WatermarkDomain

public class WatermarkViewModel: ObservableObject {
    public enum Action {
        case zoom
        case textMode
        case stickerMode(index: Int?)
    }

    @Published var page: Int = 0
    
    let format: WatermarkFormat
    let picker: AssetPicker
    let stickerPicker: AssetPicker
    let store: WatermarkStore
    
    /// nil이면 편집 불가. 워터마크를 읽기 전용으로 보여주는 화면에서 사용
    let editMode: WatermarkEditModeStore?

    var mode: WatermarkEditModeType { editMode?.mode ?? .none }

    private var cancellables = Set<AnyCancellable>()
    
    public init(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore,
        editMode: WatermarkEditModeStore? = nil,
        format: WatermarkFormat = WatermarkFormat()
    ) {
        self.picker = picker
        self.stickerPicker = stickerPicker
        self.store = store
        self.editMode = editMode
        self.format = format
        self.bind()
    }
}

private extension WatermarkViewModel {
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

        editMode?.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

public extension WatermarkViewModel {
    func action(_ action: Action) {
        switch action {
        case .zoom:
            break
        case .textMode:
            editMode?.update(editMode?.mode == WatermarkEditModeType.none ? .text : .none)
        case .stickerMode(let index):
            editMode?.selectSticker(index)
        }
    }
}

public extension WatermarkViewModel {
    func makeWatermarkTextLayout(
        watermarkImageSize: CGSize,
        containerSize: CGSize
    ) -> WatermarkTextLayout? {
        let renderSize = format.getRenderSize(
            watermarkSize: watermarkImageSize,
            containerSize: containerSize
        )
        let watermarkSize = format.getWatermarkImageSize(
            origins: picker.images,
            array: store.watermark.array
        )
        guard watermarkSize.width != .zero, watermarkSize.height != .zero else { return nil }

        let renderRatio = renderSize.width / watermarkSize.width
        let displayText = format.getDisplayText(for: store.watermark.text)
        let renderTextAreaSize = format.getTextArea(
            text: displayText,
            font: store.watermark.text.toPFont,
            fontSize: store.watermark.text.fontSize * renderRatio
        )
        let grid = format.getTextGrid(
            renderSize: renderSize,
            renderTextAreaSize: renderTextAreaSize,
            spacingRatioW: store.watermark.text.spacingWidthRatio,
            spacingRatioH: store.watermark.text.spacingHeightRatio
        )
        return WatermarkTextLayout(
            renderSize: renderSize,
            renderRatio: renderRatio,
            displayText: displayText,
            renderTextAreaSize: renderTextAreaSize,
            renderRows: grid.rows,
            renderColumns: grid.columns
        )
    }
}
