//
//  PopupWatermarkWordVM.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/4/26.
//

import Foundation
import Combine
import UISchema
import WatermarkDomain

public class PopupWatermarkWordVM: PopupViewModel {
    public enum Action {
        case appear
        case focus(_ isFocus: Bool)
        case clear
        case cancel
        case confirm
    }
    
    @Published var text: String = ""
    @Published var isFocusField: Bool = false
    
    var usecase: WatermarkUsecase
    
    // Watermark Popup Flow Step
    private let stepSubject = PassthroughSubject<WatermarkPopupFlowStep, Never>()
    public var step: AnyPublisher<WatermarkPopupFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    public init(
        usecase: WatermarkUsecase
    ) {
        self.usecase = usecase
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
        stepSubject.send(.dismiss)
    }
    
    func confirm() {
        isFocusField = false
        usecase.saveWord(text)
        stepSubject.send(.wordFinished(word: self.text))
    }
}
