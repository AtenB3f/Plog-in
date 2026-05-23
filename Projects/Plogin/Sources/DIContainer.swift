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
import PlatformExport
import RenderEngine

public class DIContainer: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        popupWatermark.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        navigation.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    @Published public var navigation = TabNavigaionCoordinator()
    @Published public var popupWatermark = WatermarkPopupCoordinator()
}

// MARK: - Tab
extension DIContainer {
    func makeTabView(_ route: TabNavigationRouter) -> some View {
        switch route {
        case .watermarkEdit:
            return makeWatermarkEditView()
        case .watermarkComplete:
            return makeWatermarkEditView()
        }
    }
    
    func makeTabNavigationVM() -> TabNavigationViewModel {
        return TabNavigationViewModel(navigation: navigation)
    }
}

// MARK: - Popup
extension DIContainer {
    func makeWatermarkPopupCoordinator() -> WatermarkPopupCoordinator {
        return popupWatermark
    }
}

// MARK: - Home
extension DIContainer {
    func makeHomeView() -> some View {
        return HomeView(
            viewModel: makeHomeVM()
        )
    }
    
    func makeHomeVM() -> HomeViewModel {
        return HomeViewModel(watermarkPopup: popupWatermark, navigation: navigation)
    }
}

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
    
    func makeWatermarkEditView() -> WatermarkEditView {
        let picker = AssetPicker(mediaType: .image, limit: 10)
        let stickerPicker = AssetPicker(mediaType: .image, limit: 10)
        let store = WatermarkStore()
        return WatermarkEditView(
            viewModel: makeWatermarkEditVM(
                picker: picker,
                stickerPicker: stickerPicker,
                store: store
            ),
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
        let watermarkStore = WatermarkDataStore()
        let usecase = WatermarkUsecase(
            wordDataStore: watermarkStore,
            watermarkDataStore: watermarkStore
        )
        return WatermarkEditViewModel(
            popup: popupWatermark,
            usecase: usecase,
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
        )
    }
}
