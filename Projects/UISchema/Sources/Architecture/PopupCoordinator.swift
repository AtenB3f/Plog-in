//
//  PopupCoordinator.swift
//  Plogin
//
//  Created by AtenB on 5/9/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import Foundation

public protocol PopupRoute {
    
}

public protocol PopupCoordinator {
    func push(_ route: PopupRoute)
    func pop()
    func popRoot()
}
