//
//  HomeFlowDI.swift
//  Plogin
//
//  Created by AtenB on 7/29/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI

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
        return HomeViewModel(navigation: navigation, watermarkPopup: popupWatermark)
    }
}

extension DIContainer {
    func startHomeFlow() {
        homeCancellables.removeAll()
        navigation.push(route: TabNavigationRouter.watermarkEdit)
    }

    internal func handleHomeStep(_ step: HomeFlowStep) {
        switch step {
        case .newWatermrk:
            startWatermarkFlow()

        case .basicWatermark:
            // pendingHomeResult = HomeResultPayload(...)
            break

        case .custromWatermark:
            // TODO: .basicWatermark와 동일한 패턴으로 구현.
            break
        }
    }
}
