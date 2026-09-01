//
//  WateramrkFlowDI.swift
//  Plogin
//
//  Created by AtenB on 7/29/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import PlatformCore
import PlatformExport
import WatermarkFeature
import WatermarkDomain
import RenderEngine

// MARK: - 워터마크 편집
extension DIContainer {
    /// 신규 워터마크 편집 플로우
    func startWatermarkFlow() {
        watermarkCancellables.removeAll()
        navigation.push(route: TabNavigationRouter.watermarkEdit(id: nil))
    }
    
    /// 기존 워터마크 편집 플로우
    /// - Parameter id: Watermark UUID
    func startWatermarkFlow(id: UUID) {
        watermarkCancellables.removeAll()
        navigation.push(route: TabNavigationRouter.watermarkEdit(id: id))
    }

    private func handleWatermarkStep(_ step: WatermarkFlowStep) {
        switch step {
        case .editFinished(let watermark, let origins):
            pendingWatermarkResult = .init(watermark: watermark, origins: origins)
            navigation.push(route: TabNavigationRouter.watermarkResult)

        case .resultFinished:
            navigation.popRoot()
            pendingWatermarkResult = nil
            watermarkCancellables.removeAll()
        }
    }
}

// MARK: - Watermark
extension DIContainer {
    func makeWatermarkVM(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore,
        editMode: WatermarkEditModeStore? = nil
    ) -> WatermarkViewModel {
        return WatermarkViewModel(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store,
            editMode: editMode
        )
    }
    
    func makeWatermarkEditView(
        id: UUID? = nil,
        picker: AssetPicker = .init(type: .watermark, crashReport: FirebaseCrashReportImpl()),
        stickerPicker: AssetPicker = .init(type: .sticker, crashReport: FirebaseCrashReportImpl()),
        store: WatermarkStore = WatermarkStore()
    ) -> WatermarkEditView {
        var watermark: WatermarkModel?
        if let id = id {
            watermark = watermarkStore.getWatermark(id: id)
        }
        let editMode = WatermarkEditModeStore()
        let editVM = makeWatermarkEditVM(
            watermark: watermark,
            picker: picker,
            stickerPicker: stickerPicker,
            store: store,
            editMode: editMode
        )
        editVM.step
            .sink { [weak self] step in
                self?.handleWatermarkStep(step)
            }
            .store(in: &watermarkCancellables)
        return WatermarkEditView(
            viewModel: editVM,
            watermarkViewModel: makeWatermarkVM(
                picker: picker,
                stickerPicker: stickerPicker,
                store: store,
                editMode: editMode
            )
        )
    }
    
    func makeWatermarkEditVM(
        watermark: WatermarkModel? = nil,
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore,
        editMode: WatermarkEditModeStore
    ) -> WatermarkEditViewModel {
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return WatermarkEditViewModel(
            watermark: watermark,
            popup: popupWatermark,
            usecase: usecase,
            picker: picker,
            stickerPicker: stickerPicker,
            store: store,
            editMode: editMode,
            crashReport: FirebaseCrashReportImpl()
        )
    }
    
    func makeWatermarkResultView(
        watermark: WatermarkModel,
        origins: [PImage]
    ) -> some View {
        let vm = makeWatermarkResultVM(watermark: watermark, origins: origins)
        vm.step
            .sink { [weak self] step in self?.handleWatermarkStep(step) }
            .store(in: &watermarkCancellables)
        return WatermarkResultView(viewModel: vm)
    }
    
    func makeWatermarkResultVM(
        watermark: WatermarkModel,
        origins: [PImage]
    ) -> WatermarkResultViewModel {
        let editor = WatermarkEditor(
            watermark: watermark,
            origins: origins,
            crashReport: FirebaseCrashReportImpl()
        )
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return WatermarkResultViewModel(
            editor: editor,
            watermarkUsecase: usecase,
            crashReport: FirebaseCrashReportImpl()
        )
    }
}
