//
//  HomeViewModel.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import PlatformCore
import WatermarkDomain
import WatermarkFeature

class HomeViewModel: ObservableObject {
    @Published var isShowPicker: Bool = false
    @Published var mediaType: MediaType = .all
    @Published var assets: [AssetData] = []
    
    private let navigation: TabNavigaionCoordinator
    private let watermarkPopup: WatermarkPopupCoordinator
    
    // Home Flow Step
    private let stepSubject = PassthroughSubject<HomeFlowStep, Never>()
    public var step: AnyPublisher<HomeFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    init(
        navigation: TabNavigaionCoordinator,
        watermarkPopup: WatermarkPopupCoordinator
    ) {
        self.navigation = navigation
        self.watermarkPopup = watermarkPopup
    }
}

@MainActor
extension HomeViewModel {
    func push(_ route: TabNavigationRouter) {
        switch route {
        case .watermarkEdit:
            stepSubject.send(.newWatermrk)
        default:
            break
        }
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
