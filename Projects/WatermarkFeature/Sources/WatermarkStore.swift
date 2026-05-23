//
//  WatermarkStore.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/21/26.
//

import Foundation
import WatermarkDomain

public class WatermarkStore: ObservableObject {
    @Published var watermark: WatermarkModel
    
    public init(
        watermark: WatermarkModel = WatermarkModel()
    ) {
        self.watermark = watermark
    }
}

public extension WatermarkStore {
    func setWatermark(_ setting: WatermarkModel) {
        watermark = setting
    }
    
    func setText(_ setting: WatermarkTextModel) {
        watermark.text = setting
    }
    
    func setSticker(_ setting: [WatermarkStickerModel]) {
        watermark.stickers = setting
    }
    
    func setArray(_ setting: WatermarkArrayModel) {
        watermark.array = setting
    }
    
    func setExport(_ setting: WatermarkExportModel) {
        watermark.export = setting
    }
    
    func setFrame(_ setting: WatermarkFrameModel) {
        watermark.frame = setting
    }
}
