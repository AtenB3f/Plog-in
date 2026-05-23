//
//  WatermarkViewModel.swift
//  Plogin
//
//  Created by AtenB on 12/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import PlatformCore
import PlatformExport
import WatermarkDomain

public class WatermarkViewModel: ObservableObject {
    public enum Action {
        case zoom
        case mode(isOn: Bool)
    }
    
//    @Published var render: WatermarkTextModel = WatermarkTextModel()
    
    @Published var isShowEdit: Bool = false
    @Published var page: Int = 0
    @Published var origins: [PImage] = []
    
    let format = WatermarkFormat()
    let picker: AssetPicker
    let stickerPicker: AssetPicker
    let store: WatermarkStore
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore
    ) {
        self.picker = picker
        self.stickerPicker = stickerPicker
        self.store = store
        self.bind()
    }
}

private extension WatermarkViewModel {
    func bind() {
        store.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        picker.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.objectWillChange.send()
                self.origins = self.picker.assets.compactMap { $0.imageAsset }
            }
            .store(in: &cancellables)
    }
}

public extension WatermarkViewModel {
    func action(_ action: Action) {
        switch action {
        case .zoom:
            break
        case .mode(let isOn):
            isShowEdit = isOn
        }
    }
}
//public extension WatermarkViewModel {
//    func calculateSetting() {
//        switch watermark.arraySetting.type {
//        case .none:
//            guard let size = images.first?.size else { break }
//            watermark.exportSetting.width = size.width
//            watermark.exportSetting.height = size.height
//        default:
//            let size = editor.getCellSize(images: images)
//            let multiple = watermark.exportSetting.multiple
//            watermark.exportSetting.width = size.width * multiple
//            watermark.exportSetting.height = size.height * multiple
//        }
//    }
    
//    func generateResults() {
//        let editor = WatermarkEditor(watermark: watermark, images: images)
//        results = editor.generateWatermarks()
//    }
//}

//public extension WatermarkViewModel {
//    func setArray(
//        type: WatermarkArrayType? = nil,
//        rows: Int? = nil,
//        columns: Int? = nil
//    ) {
//        if let type = type {
//            watermark.array.type = type
////            watermark.arraySetting.setRowColumn(originImages.count)
//        }
//        if let rows = rows { watermark.array.rows = rows }
//        if let columns = columns { watermark.array.columns = columns }
//    }
//}
