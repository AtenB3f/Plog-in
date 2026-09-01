//
//  HomeFlowDI.swift
//  Plogin
//
//  Created by AtenB on 7/29/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Persistence

// MARK: - Home
extension DIContainer {
    func makeHomeView() -> some View {
        let vm = makeHomeVM()
        vm.step
            .sink { [weak self] step in
                self?.handleHomeStep(step)
            }
            .store(in: &homeCancellables)
        return HomeView(viewModel: vm)
    }
    
    func makeHomeVM() -> HomeViewModel {
        let usecase = HomeUsecase(watermarkDataStore: watermarkStore)
        return HomeViewModel(
            navigation: navigation,
            watermarkPopup: popupWatermark,
            usecase: usecase
        )
    }
}

extension DIContainer {
    internal func handleHomeStep(_ step: HomeFlowStep) {
        switch step {
        case .newWatermrk:
            startWatermarkFlow()
            
        case .editWatermark(let id):
            startWatermarkFlow(id: id)

        case .basicWatermark(let id):
            startWatermarkPopupFlow(id: id)

        case .custromWatermark(let id):
            startWatermarkPopupFlow(id: id)
        }
    }
}
