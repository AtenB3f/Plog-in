//
//  PopupWatermarkWordVM.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/4/26.
//

import Foundation
import UISchema
import WatermarkDomain

public class PopupWatermarkWordVM: PopupViewModel {
    @Published var text: String = ""
    @Published var isFocusField: Bool = false
    
    var coordinator: WatermarkPopupCoordinator
    var usecase: WatermarkUsecase
    
    public init(
        coordinator: WatermarkPopupCoordinator,
        usecase: WatermarkUsecase
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    public enum Action {
        case appear
        case focus(_ isFocus: Bool)
        case clear
        case cancel
        case confirm
    }
}

@MainActor
public extension PopupWatermarkWordVM {
    func action(_ action: Action) {
        Task {
            switch action {
            case .appear:
                await appear()
            case .focus(let isFocus):
                focus(isFocus)
            case .clear:
                clear()
            case .cancel:
                cancel()
            case .confirm:
                confirm()
            }
        }
    }
}

@MainActor
extension PopupWatermarkWordVM {
    func appear() async {
        try? await Task.sleep(for: .microseconds(300))
        focus(true)
    }
    
    func focus(_ isFocus: Bool) {
        isFocusField = isFocus
    }
    
    func clear() {
        text = ""
    }
    
    func cancel() {
        isFocusField = false
        coordinator.pop()
    }
    
    func confirm() {
        isFocusField = false
        usecase.saveWord(text)
        coordinator.popRoot()
    }
}
