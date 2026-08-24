//
//  WatermarkEditModeStore.swift
//  WatermarkFeature
//
//  Created by AtenB on 8/24/26.
//

import Foundation

public enum WatermarkEditModeType: Equatable {
    case none
    case text
    case sticker(index: Int)

    public var stickerIndex: Int? {
        if case .sticker(let index) = self { return index }
        return nil
    }
}

public final class WatermarkEditModeStore: ObservableObject {
    @Published public private(set) var mode: WatermarkEditModeType = .none

    public init() {}
}

public extension WatermarkEditModeStore {
    func update(_ new: WatermarkEditModeType) {
        guard mode != new else { return }
        mode = new
    }

    func selectSticker(_ index: Int?) {
        update(index.map { .sticker(index: $0) } ?? .none)
    }
}
