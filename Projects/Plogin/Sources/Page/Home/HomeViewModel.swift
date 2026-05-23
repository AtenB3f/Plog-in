//
//  HomeViewModel.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore
import WatermarkDomain
import WatermarkFeature

class HomeViewModel: ObservableObject {
    @Published var isShowPicker: Bool = false
    @Published var mediaType: MediaType = .all
    @Published var assets: [AssetData] = []
    
    private let watermarkPopup: WatermarkPopupCoordinator
    private let navigation: TabNavigaionCoordinator
    
    init(
        watermarkPopup: WatermarkPopupCoordinator,
        navigation: TabNavigaionCoordinator
    ) {
        self.watermarkPopup = watermarkPopup
        self.navigation = navigation
    }
}

@MainActor
extension HomeViewModel {
    func push(_ route: TabNavigationRouter) {
        navigation.push(route: route)
    }
}

@MainActor
extension HomeViewModel {
    func clickBasicFrame(_ type: BasicWatermarkType) {
//        if let watermark = dataManager.getWatermark(type: type) {
//            manager.pushPopup(.watermarkPreview(watermark: watermark))
//        }
        switch type {
        case .melonStreaming:
            watermarkPopup.push(route: .title)
        case .melonWeekly:
            watermarkPopup.push(route: .word)
        case .youtubeStreaming:
            watermarkPopup.push(route: .preview)
        }
    }
}
