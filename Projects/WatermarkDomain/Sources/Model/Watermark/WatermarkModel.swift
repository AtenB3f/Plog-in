//
//  WatermarkModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public struct WatermarkModel {
    public var id: UUID
    public var text: WatermarkTextModel
    public var stickers: [WatermarkStickerModel]
    public var array: WatermarkArrayModel
    public var export: WatermarkExportModel
    public var frame: WatermarkFrameModel
    
    public init(
        id: UUID = UUID(),
        text: WatermarkTextModel = .init(),
        stickers: [WatermarkStickerModel] = [],
        array: WatermarkArrayModel = .init(),
        export: WatermarkExportModel = .init(),
        frame: WatermarkFrameModel = .init()
    ) {
        self.id = id
        self.text = text
        self.stickers = stickers
        self.array = array
        self.export = export
        self.frame = frame
    }
}
