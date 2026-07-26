//
//  WatermarkEntity.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
public final class WatermarkEntity: Identifiable, ObservableObject {
    public var id: UUID
    
    public var textSetting: WatermarkTextEntity
    public var stickers: [WatermarkStickerEntity]
    public var arraySetting: WatermarkArrayEntity
    public var exportSetting: WatermarkExportEntity
    public var frameSetting: WatermarkFrameEntity
    
    public init(
        textSetting: WatermarkTextEntity,
        stickers: [WatermarkStickerEntity],
        arraySetting: WatermarkArrayEntity,
        exportSetting: WatermarkExportEntity,
        frameSetting: WatermarkFrameEntity
    ) {
        self.id = UUID()
        self.textSetting = textSetting
        self.stickers = stickers
        self.arraySetting = arraySetting
        self.exportSetting = exportSetting
        self.frameSetting = frameSetting
    }
}
