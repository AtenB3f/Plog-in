//
//  AssetViewModel.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import UIKit

class AssetViewModel: ObservableObject {
    @Published var viewPath: [EditImageStep] = []
    @Published var assets: [AssetData] = []
    
    func pushNavigation(_ step: EditImageStep? = nil) {
        if let step = step {
            viewPath.append(step)
        } else {
            viewPath.removeAll()
        }
    }
    
    func filterImage() -> [UIImage] {
        let images = assets.filter { $0.imageAsset != nil }.map { $0.imageAsset! }
        return images
    }
}
