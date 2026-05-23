//
//  WatermarkPopup.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/9/26.
//

import SwiftUI

public struct WatermarkPopup: View {
    let type: WatermarkPopupRoute
    let coordinator: WatermarkPopupCoordinator
    
    public init(
        type: WatermarkPopupRoute,
        coordinator: WatermarkPopupCoordinator
    ) {
        self.type = type
        self.coordinator = coordinator
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
            PopupWatermarkText(viewModel: .init(coordinator: coordinator))
        case .preview:
            PopupWatermarkPreview(viewModel: .init(coordinator: coordinator))
        }
    }
}
