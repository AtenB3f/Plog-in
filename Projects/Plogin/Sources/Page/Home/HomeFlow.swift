//
//  HomeFlow.swift
//  Plogin
//
//  Created by AtenB on 7/29/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

public enum HomeFlowStep {
    case newWatermrk
    case basicWatermark
    case custromWatermark
}

/// Home flow의 pending-result 매커니즘 placeholder.
/// pendingWatermarkResult와 구조/수명만 동일하게 맞춰둔 상태 — .basicWatermark/.custromWatermark가
/// 아직 미구현이라 실제로 쓰는 데이터는 없음. 해당 케이스 구현 시 필드를 채울 것.
public struct HomeResultPayload {
    public init() {}
}
