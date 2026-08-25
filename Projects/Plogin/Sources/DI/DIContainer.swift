//
//  DIContainer.swift
//  Plogin
//
//  Created by AtenB on 5/9/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import Persistence
import WatermarkFeature
import WatermarkDomain
import PlatformCore
import PlatformExport
import RenderEngine

public class DIContainer: ObservableObject {
    internal var homeCancellables = Set<AnyCancellable>()
    internal var watermarkCancellables = Set<AnyCancellable>()
    internal var watermarkPopupCancellables = Set<AnyCancellable>()
    
    internal var pendingHomeResult: HomeResultPayload?
    internal var pendingWatermarkResult: WatermarkResultPayload?
    internal var pendingWatermarkPopupResult: WatermarkPopupResultPayload?
    
    internal let watermarkStore: WatermarkDataStore
    internal let imageExportRepository: PhotoLibraryExport
    
    @Published public var navigation = TabNavigaionCoordinator()
    @Published public var popupWatermark = WatermarkPopupCoordinator()
    @Published public var rootUI = RootUIManager()
    
    public init(
        watermarkStore: WatermarkDataStore = DIContainer.makeDefaultWatermarkStore(),
        imageExportRepository: PhotoLibraryExport = PhotoLibraryExport()
    ) {
        self.watermarkStore = watermarkStore
        self.imageExportRepository = imageExportRepository
    }
}

extension DIContainer {
    public static func makeDefaultWatermarkStore() -> WatermarkDataStore {
        do {
            let dataStore = try DataStore.makePersistent()
            return WatermarkDataStore(store: dataStore)
        } catch {
            fatalError("영구 저장소 초기화 실패: \(error)")
        }
    }
}

// MARK: - Tab
extension DIContainer {
    func makeTabView(_ route: TabNavigationRouter) -> some View {
        switch route {
        case .watermarkEdit:
            return AnyView(makeWatermarkEditView())
        case .watermarkComplete:
            return AnyView(makeWatermarkEditView())
        case .watermarkResult:
            guard let pending = pendingWatermarkResult else {
                return AnyView(EmptyView())
            }
            return AnyView(makeWatermarkResultView(watermark: pending.watermark, origins: pending.origins))
        }
    }
    
    func makeTabNavigationVM() -> TabNavigationViewModel {
        return TabNavigationViewModel(navigation: navigation)
    }
}

// MARK: - Popup
extension DIContainer {
    func makeWatermarkPopup(_ route: WatermarkPopupRoute) -> some View {
        switch route {
        case .title:
            return AnyView(PopupWatermarkTitle(viewModel: makePopupWatermarkTitleVM()))
        case .word:
            return AnyView(PopupWatermarkWord(viewModel: makePopupWatermarkWordVM()))
        case .preview(let id):
            return AnyView(PopupWatermarkPreview(viewModel: makePopupWatermarkPreviewVM(id: id)))
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
    
    func makePopupWatermarkPreview(id: UUID) -> PopupWatermarkPreview {
        return PopupWatermarkPreview(viewModel: makePopupWatermarkPreviewVM(id: id))
    }
    
    func makePopupWatermarkPreviewVM(id: UUID) -> PopupWatermarkPreviewVM {
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore,
            imageExportRepository: imageExportRepository
        )
        return PopupWatermarkPreviewVM(
            id: id,
            usecase: usecase,
            coodinator: popupWatermark
        )
    }
    
    internal func handleWatermarkPopupStep(_ step: WatermarkPopupFlowStep) {
        if pendingWatermarkPopupResult == nil {
            pendingWatermarkPopupResult = .init()
        }
        switch step {
        case .dismiss:
            popupWatermark.pop()
        case .wordFinished(let word):
            pendingWatermarkPopupResult?.word = word
            popupWatermark.pop()
        case .titleFinished(let title):
            pendingWatermarkPopupResult?.title = title
            popupWatermark.pop()
        case .previewFinished:
            popupWatermark.popRoot()
        }
    }
}
