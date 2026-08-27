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
import PlatformExport
import Persistence
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
    @Published var text: String = ""
    
    @Published var isShowPicker: Bool = false
    @Published var pickerType: WatermarkEditPickerType?
    
    private let usecase: WatermarkUsecase
    private let coodinator: WatermarkPopupCoordinator
    private let store: WatermarkStore
    private let format: WatermarkFormat = WatermarkFormat()
    let picker: AssetPicker
    private var editor: WatermarkEditor?
    
    public init(
        id: UUID,
        usecase: WatermarkUsecase,
        coodinator: WatermarkPopupCoordinator,
        store: WatermarkStore,
        picker: AssetPicker
    ) {
        self.usecase = usecase
        self.coodinator = coodinator
        self.store = store
        self.picker = picker
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
}

@MainActor
extension PopupWatermarkPreviewVM {
    func appear() async {
        // text가 이미 채워져 있다면(예: Word 팝업에서 applyWord(_:)로 방금 반영된 경우)
        // usecase에서 다시 불러와 덮어쓰지 않는다.
        if text.isEmpty {
            await loadWord()
        }
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
            if text.isEmpty {
                await loadWord()
            }
            makeTextModel()
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

extension PopupWatermarkPreviewVM {
    /// Word 팝업에서 저장된 문구를 반영한다. DIContainer.handleWatermarkPopupStep이
    /// .wordFinished를 처리할 때 sessionWatermarkPopup을 통해 직접 호출한다.
    /// usecase.fetchWords()를 다시 조회하는 대신 이벤트로 받은 값을 그대로 반영해서
    /// 저장 순서 보장이 없는 DB 재조회에 의존하지 않도록 한다.
    public func applyWord(_ word: String) {
        text = word
        store.watermark.text.text = word

        // 이미 사진을 골라 previews(저장용 렌더 결과)를 만든 상태라면 최신 문구로 다시 만든다.
        guard !picker.images.isEmpty else { return }
        setEditor()
        makePreview()
    }
}

private extension PopupWatermarkPreviewVM {
    func setEditor() {
        editor = WatermarkEditor(watermark: store.watermark, origins: picker.images)
    }
    
    @MainActor
    func loadWord() async {
        if let last = usecase.fetchWords().last {
            text = last.text
            store.watermark.text.text = text
        } else {
            input()
        }
    }

    func makeTextModel() {
        if !picker.images.isEmpty {
            store.watermark.text.fontName = FontType.body1.fontName
            store.watermark.text.date = Date()
            format.makeTextModel(
                origins: picker.images,
                array: store.watermark.array,
                current: &store.watermark.text
            )
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
