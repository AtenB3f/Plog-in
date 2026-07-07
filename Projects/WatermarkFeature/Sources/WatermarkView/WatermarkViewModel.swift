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
        case textMode(isOn: Bool)
        case stickerMode(index: Int?)
    }

    @Published var isShowEdit: Bool = false
    @Published var selectedStickerIndex: Int?
    @Published var page: Int = 0
    
    let format: WatermarkFormat
    let picker: AssetPicker
    let stickerPicker: AssetPicker
    let store: WatermarkStore
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        picker: AssetPicker,
        stickerPicker: AssetPicker,
        store: WatermarkStore,
        format: WatermarkFormat = WatermarkFormat()
    ) {
        self.picker = picker
        self.stickerPicker = stickerPicker
        self.store = store
        self.format = format
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
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

public extension WatermarkViewModel {
    func action(_ action: Action) {
        switch action {
        case .zoom:
            break
        case .textMode(let isOn):
            guard !isOn else {
                isShowEdit = false
                return
            }
            if selectedStickerIndex != nil {
                selectedStickerIndex = nil
            } else {
                isShowEdit.toggle()
            }
        case .stickerMode(let index):
            selectedStickerIndex = index
            if index != nil { isShowEdit = false }
        }
    }
}
