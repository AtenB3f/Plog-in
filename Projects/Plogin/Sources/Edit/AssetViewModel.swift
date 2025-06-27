//
//  AssetViewModel.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import Foundation

class AssetViewModel: ObservableObject {
    @Published var viewPath: [EditStep] = []
    @Published var assets: [AssetData] = []
    
    func pushNavigation(_ step: EditStep? = nil) {
        if let step = step {
            viewPath.append(step)
        } else {
            viewPath.removeAll()
        }
    }
}
