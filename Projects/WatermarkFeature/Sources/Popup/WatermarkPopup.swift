//
//  WatermarkPopup.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/9/26.
//

import SwiftUI
import WatermarkDomain

public struct WatermarkPopup: View {
    let type: WatermarkPopupRoute
    let coordinator: WatermarkPopupCoordinator
    let usecase: WatermarkUsecase
    
    public init(
        type: WatermarkPopupRoute,
        coordinator: WatermarkPopupCoordinator,
        usecase: WatermarkUsecase
    ) {
        self.type = type
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    public var body: some View {
        ZStack {
            Color.Shadow.medium
                .ignoresSafeArea()
            
            Group {
                makePopup()
            }
            .padding(.horizontal, 30)
        }
    }
    
    @ViewBuilder
    func makePopup() -> some View {
        switch type {
        case .title:
            PopupWatermarkTitle(viewModel: .init(coordinator: coordinator))
        case .word:
            PopupWatermarkWord(viewModel: .init(coordinator: coordinator, usecase: usecase))
        case .preview:
            PopupWatermarkPreview(viewModel: .init(coordinator: coordinator))
        }
    }
}
