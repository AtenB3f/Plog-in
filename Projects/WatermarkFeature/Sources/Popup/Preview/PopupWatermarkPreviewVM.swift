//
//  PopupWatermarkPreviewVM.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import Photos
import UISchema
import PlatformCore
import CoreDomain
import PlatformExport
import RenderEngine
import WatermarkDomain

public class PopupWatermarkPreviewVM: PopupViewModel {
    enum Action {
        case appear
        case input
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
    private var cancellables = Set<AnyCancellable>()
    // 선택한 사진 중 접근 권한이 없는 사진이 있는지. 로드 완료(.finished) 시 처리
    private var isLimitedAccess = false

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
        bind()
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
        if let route = await picker.authorize().deniedRoute {
            cancel()
            coodinator.push(route: route)
            return
        }
        isShowPicker = true
    }

    // 문구 입력
    func input() {
        coodinator.stepSubject.send(.wordStart)
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
    func bind() {
        picker.event
            .sink { [weak self] event in
                guard let self = self else { return }
                Task {
                    await self.eventHandler(event)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func eventHandler(_ event: AssetPickerEvent) {
        switch event {
        case .error(let error):
            switch error {
            case .limitedAccess:
                isLimitedAccess = true
            default:
                break
            }
        case .finished:
            if isLimitedAccess {
                // 사진 접근 권한 팝업은 미리보기 팝업을 닫은 뒤 표시
                isLimitedAccess = false
                cancel()
                coodinator.push(route: .photoLimited)
            } else {
                select()
            }
        }
    }

    // 이미지 로드 완료 후 미리보기 생성. 선택한 이미지가 없으면(취소) 팝업 닫기
    @MainActor
    func select() {
        if picker.images.isEmpty {
            cancel()
        } else {
            usecase.setupWatermark(origins: picker.images, current: &store.watermark)
            setEditor()
            makePreview()
        }
    }

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
