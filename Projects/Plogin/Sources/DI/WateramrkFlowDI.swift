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

// MARK: - Watermark
extension DIContainer {
    func makeWatermarkVM(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore
    ) -> WatermarkViewModel {
        return WatermarkViewModel(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
        )
    }
    
    func makeWatermarkEditView(
        picker: AssetPicker = AssetPicker(mediaType: .image, limit: 36),
        stickerPicker: AssetPicker = AssetPicker(mediaType: .image, limit: 10),
        store: WatermarkStore = WatermarkStore()
    ) -> WatermarkEditView {
        let editVM = makeWatermarkEditVM(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
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
                store: store
            )
        )
    }
    
    func makeWatermarkEditVM(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore
    ) -> WatermarkEditViewModel {
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return WatermarkEditViewModel(
            popup: popupWatermark,
            usecase: usecase,
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
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
            origins: origins
        )
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return WatermarkResultViewModel(editor: editor, watermarkUsecase: usecase)
    }
}

extension DIContainer {
    func startWatermarkFlow() {
        watermarkCancellables.removeAll()
        navigation.push(route: TabNavigationRouter.watermarkEdit)
    }

    private func handleWatermarkStep(_ step: WatermarkFlowStep) {
        switch step {
        case .editFinished(let watermark, let origins):
            pendingWatermarkResult = (watermark: watermark, origins: origins)
            navigation.push(route: TabNavigationRouter.watermarkResult)

        case .resultFinished:
            navigation.popRoot()
            pendingWatermarkResult = nil
            watermarkCancellables.removeAll()
        }
    }
}
