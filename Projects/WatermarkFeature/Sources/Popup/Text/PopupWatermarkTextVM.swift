//
//  PopupWatermarkTextVM.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/4/26.
//

import Foundation
import UISchema

class PopupWatermarkTextVM: PopupViewModel {
    @Published var text: String = ""
    
    var coordinator: WatermarkPopupCoordinator
    init(
        coordinator: WatermarkPopupCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    enum Action {
        case input
        case clear
        case cancel
        case confirm
    }
}

@MainActor
extension PopupWatermarkTextVM {
    func action(_ action: Action) {
        switch action {
        case .input:
            input()
        case .clear:
            clear()
        case .cancel:
            cancel()
        case .confirm:
            confirm()
        }
    }
}

@MainActor
extension PopupWatermarkTextVM {
    func input() {
        
    }
    
    func clear() {
        text = ""
    }
    
    func cancel() {
        // popup dismiss
        coordinator.pop()
    }
    
    func confirm() {
        // data save
        // popup dismiss
        coordinator.popRoot()
    }
}
