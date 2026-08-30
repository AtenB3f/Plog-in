//
//  WateramrkPopupFlowDI.swift
//  Plogin
//
//  Created by AtenB on 8/25/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import PlatformCore
import PlatformExport
import WatermarkFeature
import WatermarkDomain
import RenderEngine

/// Preview 팝업이 Word 팝업을 오가는 동안 재사용되는 세션
/// picker/store에 담긴 선택 이미지와 편집 중인 내용 유지
struct WatermarkPreviewSession {
    let id: UUID
    let viewModel: PopupWatermarkPreviewVM
    let watermarkVM: WatermarkViewModel
}

// MARK: - Watermark Popup
extension DIContainer {
    func bindWatermarkPopupFlow() {
        popupWatermark.step
            .sink { [weak self] step in self?.handleWatermarkPopupStep(step) }
            .store(in: &watermarkPopupCancellables)
    }

    /// 워터마크 팝업 진입
    /*
     case 1. WatermarkEditView -> PopupWatermarkWord
        - PopupWatermarkWord -> wordStart -> dismiss
        - PopupWatermarkWord -> wordStart -> wordFinished

     case 2. WatermarkEditView -> PopupWatermarkTitle
        - PopupWatermarkTitle -> dismiss
        - PopupWatermarkTitle -> titleFinished

     case 3. Root -> PopupWatermarkPreview
        - PopupWatermarkPreview -> dismiss
        - PopupWatermarkPreview -> previewFinished
        - PopupWatermarkPreview -> wordStart -> dismiss -> dismiss/previewFinished
        - PopupWatermarkPreview -> wordStart -> wordFinished -> dismiss/previewFinished
     */
    func startWatermarkPopupFlow(id: UUID) {
        guard popupWatermark.path.isEmpty else { return }
        pendingWatermarkPopupResult = .init()
        popupWatermark.push(route: .preview(id: id))
    }

    // case 3(Root -> PopupWatermarkPreview)에서 시작된 스텝만 처리
    // case 1,2는 다른 네비게이션 ViewModel에서 구독하여 사용
    internal func handleWatermarkPopupStep(_ step: WatermarkPopupFlowStep) {
        guard pendingWatermarkPopupResult != nil else { return }

        switch step {
        case .dismiss:
            popupWatermark.pop()
        case .wordStart:
            popupWatermark.push(route: .word)
        case .wordFinished(let word):
            pendingWatermarkPopupResult?.word = word
            sessionWatermarkPopup?.viewModel.applyWord(word)
            popupWatermark.pop()
        case .titleFinished(let title):
            pendingWatermarkPopupResult?.title = title
            popupWatermark.pop()
        case .previewFinished:
            popupWatermark.popRoot()
        }

        if popupWatermark.path.isEmpty {
            pendingWatermarkPopupResult = nil
            sessionWatermarkPopup = nil
        }
    }
}

extension DIContainer {
    func makeWatermarkPopup(_ route: WatermarkPopupRoute) -> some View {
        switch route {
        case .title:
            return AnyView(PopupWatermarkTitle(viewModel: makePopupWatermarkTitleVM()))
        case .word:
            return AnyView(PopupWatermarkWord(viewModel: makePopupWatermarkWordVM()))
        case .preview(let id):
            return AnyView(makePopupWatermarkPreview(id: id))
        }
    }
    
    func makeWatermarkPopupUsecase() -> WatermarkUsecase {
        return WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
    }
    
    func makeWatermarkPopupCoordinator() -> WatermarkPopupCoordinator {
        return popupWatermark
    }
    
    func makePopupWatermarkTitle() -> PopupWatermarkTitle {
        return PopupWatermarkTitle(viewModel: makePopupWatermarkTitleVM())
    }
    
    func makePopupWatermarkTitleVM() -> PopupWatermarkTitleVM {
        return PopupWatermarkTitleVM(coodinator: popupWatermark)
    }
    
    func makePopupWatermarkWord() -> PopupWatermarkWord {
        return PopupWatermarkWord(viewModel: makePopupWatermarkWordVM())
    }
    
    func makePopupWatermarkWordVM() -> PopupWatermarkWordVM {
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return PopupWatermarkWordVM(
            usecase: usecase,
            coodinator: popupWatermark
        )
    }
    
    /// - Parameter id: WatermarkModel UUID
    func makePopupWatermarkPreview(id: UUID) -> PopupWatermarkPreview {
        if let session = sessionWatermarkPopup, session.id == id {
            return PopupWatermarkPreview(viewModel: session.viewModel, wateramrkVM: session.watermarkVM)
        }
        
        let watermark = watermarkStore.getWatermark(id: id) ?? WatermarkModel()
        
        let picker = AssetPicker(
            mediaType: .image,
            limit: watermark.frame.code == BasicWatermarkType.youtubeStreaming.rawValue ? 2 : 30
        )
        let store = WatermarkStore(watermark: watermark)
        let viewModel = makePopupWatermarkPreviewVM(id: id, store: store, picker: picker)
        let watermarkVM = makeWatermarkVM(picker: picker, stickerPicker: picker, store: store)

        sessionWatermarkPopup = WatermarkPreviewSession(id: id, viewModel: viewModel, watermarkVM: watermarkVM)
        return PopupWatermarkPreview(viewModel: viewModel, wateramrkVM: watermarkVM)
    }
    
    func makePopupWatermarkPreviewVM(
        id: UUID,
        store: WatermarkStore,
        picker: AssetPicker
    ) -> PopupWatermarkPreviewVM {
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return PopupWatermarkPreviewVM(
            id: id,
            usecase: usecase,
            coodinator: popupWatermark,
            store: store,
            picker: picker
        )
    }
}
