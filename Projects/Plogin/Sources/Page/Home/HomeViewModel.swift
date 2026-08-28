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
import Persistence

class HomeViewModel: ObservableObject {
    @Published var isShowPicker: Bool = false
    @Published var mediaType: MediaType = .all
    @Published var assets: [AssetData] = []
    
    private let navigation: TabNavigaionCoordinator
    private let watermarkPopup: WatermarkPopupCoordinator
    private let watermarkStore: WatermarkDataStore
    
    // Home Flow Step
    private let stepSubject = PassthroughSubject<HomeFlowStep, Never>()
    public var step: AnyPublisher<HomeFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    init(
        navigation: TabNavigaionCoordinator,
        watermarkPopup: WatermarkPopupCoordinator,
        watermarkStore: WatermarkDataStore
    ) {
        self.navigation = navigation
        self.watermarkPopup = watermarkPopup
        self.watermarkStore = watermarkStore
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
        var basics = watermarkStore.getWatermarks(type: .basic)
        
        // 기본 프레임이 없는 경우
        if basics.isEmpty {
            for type in BasicWatermarkType.allCases {
                if let pimage = PImage(named: type.rawValue) {
                    let wateramrk = type.watermark(thumnail: pimage)
                    watermarkStore.setWatermark(wateramrk)
                } else {
                    let wateramrk = type.watermark
                    watermarkStore.setWatermark(wateramrk)
                }
            }
            basics = watermarkStore.getWatermarks(type: .basic)
        }
        let frames = basics.filter({ $0.frame.code == type.rawValue })
        guard let id = frames.first?.id else { return }
        stepSubject.send(.basicWatermark(id: id))
    }
}
