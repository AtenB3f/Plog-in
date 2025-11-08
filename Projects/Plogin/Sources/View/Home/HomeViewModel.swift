//
//  HomeViewModel.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowPicker: Bool = false
    @Published var mediaType: MediaType = .all
    @Published var assets: [AssetData] = []
    
    
    @Published var manager = AppManager.shared
    @MainActor private let dataManager = DataStore.shared
    
}
extension HomeViewModel {
    @MainActor
    func clickBasicFrame(_ type: BasicWatermarkType) {
        if let watermark = dataManager.getWatermark(type: type) {
            manager.pushPopup(.watermarkPreview(watermark: watermark))
        }
    }
}
