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
    @Published var title: String
    
    // Watermark Popup Flow Step
    private let stepSubject = PassthroughSubject<WatermarkPopupFlowStep, Never>()
    public var step: AnyPublisher<WatermarkPopupFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    public init(
        title: String = ""
    ) {
        self.title = title
    }
    
    public enum Action {
        case input
        case clear
        case cancel
        case confirm
    }
}

@MainActor
public extension PopupWatermarkTitleVM {
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
private extension PopupWatermarkTitleVM {
    func input() {
        
    }
    
    func clear() {
        title = ""
    }
    
    func cancel() {
//        coordinator.pop()
        
        stepSubject.send(.dismiss)
    }
    
    func confirm() {
        // data save
        
        stepSubject.send(.titleFinished(title: self.title))
    }
}
