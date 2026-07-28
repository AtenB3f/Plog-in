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
