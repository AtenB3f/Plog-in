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
    public var prevPath: WatermarkPopupRoute? {
        guard path.count > 1 else { return nil }
        return path[path.count - 2]
    }
    // Watermark Popup Flow Step
    public let stepSubject = PassthroughSubject<WatermarkPopupFlowStep, Never>()
    public var step: AnyPublisher<WatermarkPopupFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
        
    public init() {}
}

extension WatermarkPopupCoordinator: PopupCoordinator {
    public func push(_ route: any PopupRoute) {
        guard let route = route as? WatermarkPopupRoute else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            path.append(route)
        }
    }

    public func push(route: WatermarkPopupRoute) {
        push(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            path.removeLast()
        }
    }

    public func popRoot() {
        withAnimation(.easeInOut(duration: 0.25)) {
            path.removeAll()
        }
    }
}

public enum WatermarkPopupRoute: PopupRoute {
    /// 워터마크 제목 설정
    case title
    
    /// 워터마크 문구 설정
    case word
    
    /// 워터마크 미리보기, 워터마크 생성 shortcut
    /// - Parameter id: WatermarkModel UUID
    case preview(id: UUID)
}
