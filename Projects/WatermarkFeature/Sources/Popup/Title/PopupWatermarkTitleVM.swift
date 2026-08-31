//
//  PopupWatermarkTitleVM.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/7/26.
//

import SwiftUI
import Combine
import UISchema

public class PopupWatermarkTitleVM: PopupViewModel {
    public enum Action {
        case appear
        case focus(_ isFocus: Bool)
        case clear
        case cancel
        case confirm
    }
    
    @Published var text: String = ""
    @Published var isFocusField: Bool = false
    
    var coodinator: WatermarkPopupCoordinator
    
    public init(
        coodinator: WatermarkPopupCoordinator
    ) {
        self.coodinator = coodinator
    }
}

@MainActor
public extension PopupWatermarkTitleVM {
    @MainActor
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
private extension PopupWatermarkTitleVM {
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
        coodinator.stepSubject.send(.dismiss)
    }
    
    func confirm() {
        isFocusField = false
        coodinator.stepSubject.send(.titleFinished(title: self.text))
    }
}
