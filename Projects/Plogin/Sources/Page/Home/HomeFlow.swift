//
//  HomeFlow.swift
//  Plogin
//
//  Created by AtenB on 7/29/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import Foundation

public enum HomeFlowStep {
    case newWatermrk
    case editWatermark(id: UUID)
    case basicWatermark(id: UUID)
    case custromWatermark(id: UUID)
}

public struct HomeResultPayload {
    public init() {}
}
