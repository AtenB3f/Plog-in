//
//  WatermarkPopupCoordinator.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/9/26.
//

import SwiftUI
import UISchema

public class WatermarkPopupCoordinator: ObservableObject {
    @Published public var path: [WatermarkPopupRoute] = []
    @Published public var history: WatermarkPopupRoute?
    public init() {}
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
            history = path.last
            path.removeLast()
        }
    }
    
    public func popRoot() {
        withAnimation {
            history = path.last
            path.removeAll()
        }
    }
}

public enum WatermarkPopupRoute: PopupRoute {
    case title
    case word
    case preview
}
