//
//  WatermarkModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
public final class WatermarkModel: Identifiable {
    public var id: UUID
    
    var textSetting: WatermarkTextModel
    var stikers: [WatermarkStikerModel]
    var arraySetting: WatermarkArrayModel
    var exportSetting: WatermarkExportModel
    var frameSetting: WatermarkFrameModel
    
    init(
        textSetting: WatermarkTextModel,
        stikers: [WatermarkStikerModel],
        arraySetting: WatermarkArrayModel,
        exportSetting: WatermarkExportModel,
        frameSetting: WatermarkFrameModel
    ) {
        self.id = UUID()
        self.textSetting = textSetting
        self.stikers = stikers
        self.arraySetting = arraySetting
        self.exportSetting = exportSetting
        self.frameSetting = frameSetting
    }
}
