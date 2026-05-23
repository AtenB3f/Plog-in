//
//  TabNavigationViewModel.swift
//  Plogin
//
//  Created by AtenB on 5/15/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import Foundation

class TabNavigationViewModel: ObservableObject {
    let navigation:  TabNavigaionCoordinator
    
    init(
        navigation: TabNavigaionCoordinator
    ) {
        self.navigation = navigation
    }
    
}
