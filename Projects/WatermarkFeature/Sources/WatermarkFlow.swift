//
//  WatermarkFlow.swift
//  WatermarkFeature
//
//  Created by AtenB on 7/28/26.
//

import PlatformCore
import WatermarkDomain

public enum WatermarkFlowStep {
    case editFinished(watermark: WatermarkModel, origins: [PImage])
    case resultFinished
}

public enum WatermarkPopupFlowStep {
    case dismiss
    case wordFinished(word: String)
    case titleFinished(title: String)
    case previewFinished
}

public struct WatermarkResultPayload {
    public var watermark: WatermarkModel
    public var origins: [PImage]
    
    public init(
        watermark: WatermarkModel,
        origins: [PImage]
    ) {
        self.watermark = watermark
        self.origins = origins
    }
}

public struct WatermarkPopupResultPayload {
    public var title: String?
    public var word: String?
    
    public init(
        title: String? = nil,
        word: String? = nil
    ) {
        self.title = title
        self.word = word
    }
}
