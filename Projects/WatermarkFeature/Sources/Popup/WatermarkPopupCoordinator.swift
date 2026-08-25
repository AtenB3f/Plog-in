//
//  WatermarkPopupCoordinator.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/9/26.
//

import SwiftUI
import Combine
import UISchema

public class WatermarkPopupCoordinator: ObservableObject {
    @Published public var path: [WatermarkPopupRoute] = []
    public init() {}
    
    // Watermark Popup Flow Step
    public let stepSubject = PassthroughSubject<WatermarkPopupFlowStep, Never>()
    public var step: AnyPublisher<WatermarkPopupFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
}

extension WatermarkPopupCoordinator: PopupCoordinator {
    public func push(_ route: any PopupRoute) {
        guard let route = route as? WatermarkPopupRoute else { return }
        withAnimation {
            path.append(route)
        }
    }
    
    public func push(route: WatermarkPopupRoute) {
        push(route)
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        withAnimation {
            path.removeLast()
        }
    }
    
    public func popRoot() {
        withAnimation {
            path.removeAll()
        }
    }
}

public enum WatermarkPopupRoute: PopupRoute {
    case title
    case word
    case preview(id: UUID)
}
