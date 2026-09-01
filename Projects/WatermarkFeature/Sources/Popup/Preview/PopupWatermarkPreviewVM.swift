//
//  PopupWatermarkPreviewVM.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import UISchema
import Design
import PlatformCore
import CoreDomain
import PlatformExport
import RenderEngine
import WatermarkDomain

public class PopupWatermarkPreviewVM: PopupViewModel {
    enum Action {
        case appear
        case input
        case select
        case cancel
        case confirm
    }
    
    @Published var previews: [PImage] = []

    @Published var isShowPicker: Bool = false
    @Published var pickerType: WatermarkEditPickerType?
    
    private let usecase: WatermarkUsecase
    private let coodinator: WatermarkPopupCoordinator
    let store: WatermarkStore
    let picker: AssetPicker
    private var editor: WatermarkEditor?
    private let crashReport: CrashReport?

    public init(
        id: UUID,
        usecase: WatermarkUsecase,
        coodinator: WatermarkPopupCoordinator,
        store: WatermarkStore,
        picker: AssetPicker,
        crashReport: CrashReport? = nil
    ) {
        self.usecase = usecase
        self.coodinator = coodinator
        self.store = store
        self.picker = picker
        self.crashReport = crashReport
        super.init()
        _ = loadWatermark(id: id)
    }
}

extension PopupWatermarkPreviewVM {
    @MainActor
    func action(_ action: Action) {
        Task {
            switch action {
            case .appear:
                await appear()
            case .input:
                input()
            case .select:
                await select()
            case .cancel:
                cancel()
            case .confirm:
                await confirm()
            }
        }
    }
    
    public func applyWord(_ word: String) {
        store.watermark.text.text = word

        guard !picker.images.isEmpty else { return }
        setEditor()
        makePreview()
    }
}

@MainActor
extension PopupWatermarkPreviewVM {
    func appear() async {
        guard picker.images.isEmpty else { return }
        isShowPicker = true
    }

    // 문구 입력
    func input() {
        coodinator.stepSubject.send(.wordStart)
    }

    func select() async {
        if picker.images.isEmpty {
            cancel()
        } else {
            usecase.setupWatermark(origins: picker.images, current: &store.watermark)
            setEditor()
            makePreview()
        }
    }

    func cancel() {
        coodinator.stepSubject.send(.dismiss)
    }

    func confirm() async {
        _ = await usecase.saveWatermarkImage(previews)
        coodinator.stepSubject.send(.previewFinished)
    }
}

private extension PopupWatermarkPreviewVM {
    func setEditor() {
        editor = WatermarkEditor(
            watermark: store.watermark,
            origins: picker.images,
            crashReport: crashReport
        )
    }
    
    @MainActor
    func loadWord() async {
        if let recent = usecase.fetchWords().first {
            store.watermark.text.text = recent.text
        } else {
            input()
        }
    }

    func loadWatermark(id: UUID) -> WatermarkModel {
        let watermarks = usecase.fetchWatermarks()
        if let watermark = watermarks.first(where: { $0.id == id }) {
            store.watermark = watermark
        }
        return store.watermark
    }
    
    func makePreview() {
        if let images = editor?.generateWatermarks() {
            previews = images
        }
    }
}
