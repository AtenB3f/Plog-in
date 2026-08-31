//
//  HomeUsecase.swift
//  Plogin
//
//  Created by AtenB on 8/31/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import WatermarkDomain

public class HomeUsecase {
    let watermarkDataStore: any WatermarkRepository

    public init(
        watermarkDataStore: any WatermarkRepository
    ) {
        self.watermarkDataStore = watermarkDataStore
    }
}

extension HomeUsecase {
    func fetchWatermarks(type: WatermarkFrameType) -> [WatermarkModel] {
        watermarkDataStore.getWatermarks(type: type)
    }
    
    func setWatermark(_ watermark: WatermarkModel) {
        watermarkDataStore.setWatermark(watermark)
    }
}
