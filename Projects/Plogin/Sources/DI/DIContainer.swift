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
    internal var sessionWatermarkPopup: WatermarkPreviewSession?

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
        bindWatermarkPopupFlow()
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
        case .watermarkEdit(let id):
            return AnyView(makeWatermarkEditView(id: id))
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
