//
//  WatermarkModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData
import Design

@Model
public final class WatermarkModel: Identifiable, ObservableObject {
    public var id: UUID
    
    var textSetting: WatermarkTextModel
    var stikers: [WatermarkStikerModel]
    var arraySetting: WatermarkArrayModel
    var exportSetting: WatermarkExportModel
    var frameSetting: WatermarkFrameModel
    
    init(
        textSetting: WatermarkTextModel = .init(
            text: "",
            fontName: FontType.body4.fontName,
            fontSize: FontType.body4.size,
            rotation: -20,
            color: .Gray.medium,
            alpha: 0.3,
            spacing: .init(width: 20, height: 20),
            isGradient: true,
            isDate: true),
        stikers: [WatermarkStikerModel] = [],
        arraySetting: WatermarkArrayModel = .init(type: .none, rows: 1, columns: 1),
        exportSetting: WatermarkExportModel = .init(type: .auto, size: .zero),
        frameSetting: WatermarkFrameModel = .init(title: "제목 없음", type: .custom)
    ) {
        self.id = UUID()
        self.textSetting = textSetting
        self.stikers = stikers
        self.arraySetting = arraySetting
        self.exportSetting = exportSetting
        self.frameSetting = frameSetting
    }
}
