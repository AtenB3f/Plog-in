//
//  TabNavigaionCoordinator.swift
//  Plogin
//
//  Created by AtenB on 5/15/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import UISchema

public class TabNavigaionCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    public init() {}
}

extension TabNavigaionCoordinator: NavigationCoordinator {
    public func push(route: any NavigationRoute) {
        guard let route = route as? TabNavigationRouter else { return }
        withAnimation {
            path.append(route)
        }
    }
    
    public func push(_ route: any UISchema.NavigationRoute) {
        withAnimation {
            path.append(route)
        }
    }
    
    public func pop() {
        withAnimation {
            path.removeLast()
        }
    }
    
    public func popRoot() {
        withAnimation {
            path = NavigationPath()
        }
    }
}
