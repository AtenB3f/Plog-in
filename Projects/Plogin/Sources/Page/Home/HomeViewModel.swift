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
    enum Action {
        case appear
        case shortcutWatermark(type: BasicWatermarkType)
        case editWatermark(id: UUID?)
    }
    
    @Published var customWatermarks: [HomeCustomFrameViewState] = []
    
    private let navigation: TabNavigaionCoordinator
    private let watermarkPopup: WatermarkPopupCoordinator
    private let usecase: HomeUsecase
    
    // Home Flow Step
    private let stepSubject = PassthroughSubject<HomeFlowStep, Never>()
    public var step: AnyPublisher<HomeFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    init(
        navigation: TabNavigaionCoordinator,
        watermarkPopup: WatermarkPopupCoordinator,
        usecase: HomeUsecase
    ) {
        self.navigation = navigation
        self.watermarkPopup = watermarkPopup
        self.usecase = usecase
    }
}

@MainActor
extension HomeViewModel {
    func action(_ action: Action) {
        Task {
            switch action {
            case .appear:
                appear()
            case .shortcutWatermark(let type):
                basicPopup(type)
            case .editWatermark(let id):
                push(.watermarkEdit(id: id))
            }
        }
    }
}

@MainActor
private extension HomeViewModel {
    func appear() {
        let watermarks = usecase.fetchWatermarks(type: .custom)
        customWatermarks = watermarks.map { .init(
            id: $0.id,
            title: $0.frame.title,
            thumbnail: PImage(data: $0.frame.thumbnailData ?? Data()) ?? PImage()
        )}
    }
    
    func push(_ route: TabNavigationRouter) {
        switch route {
        case .watermarkEdit(let id):
            if let id = id {
                stepSubject.send(.editWatermark(id: id))
            } else {
                stepSubject.send(.newWatermrk)
            }
        default:
            break
        }
    }

    func basicPopup(_ type: BasicWatermarkType) {
        var basics = usecase.fetchWatermarks(type: .basic)
        
        // 기본 프레임이 없는 경우 신규 프레임 저장
        if basics.isEmpty {
            for type in BasicWatermarkType.allCases {
                if let pimage = PImage(named: type.rawValue) {
                    let wateramrk = type.watermark(thumnail: pimage)
                    usecase.setWatermark(wateramrk)
                } else {
                    let wateramrk = type.watermark
                    usecase.setWatermark(wateramrk)
                }
            }
            basics = usecase.fetchWatermarks(type: .basic)
        }
        let frames = basics.filter({ $0.frame.code == type.rawValue })
        guard let id = frames.first?.id else { return }
        stepSubject.send(.basicWatermark(id: id))
    }
}
