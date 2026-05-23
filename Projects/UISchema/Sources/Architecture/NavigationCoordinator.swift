//
//  NavigationCoordinator.swift
//  Plogin
//
//  Created by AtenB on 5/15/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI

public protocol NavigationRoute: Hashable { }

public protocol NavigationCoordinator {
    func push(_ route: NavigationRoute)
    func pop()
    func popRoot()
}
