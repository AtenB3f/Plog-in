//
//  PopupView.swift
//  Plogin
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

public enum PopupType {
    case watermarkTextSave(text: Binding<String> ,callback: (Bool) -> Void)
    case watermarkPreview(watermark: WatermarkModel)
    case preview
    case titleChange(text: Binding<String>, callback: (String?) -> Void)
}

public struct PopupView: View {
    @StateObject var manager = AppManager.shared
    
    let type: PopupType
    
    public var body: some View {
        if let type = manager.rootPopup {
            ZStack {
                Color.Shadow.medium
                    .ignoresSafeArea()
                
                switch type {
                case .watermarkTextSave(let text, let callback):
                    PopupWatermarkText(text: text, callback: callback)
                    
                case .preview:
                    PopupPreviewView()
                    
                case .watermarkPreview(let watermark):
                    PopupWatermarkPreview(watermark: watermark)
                    
                case .titleChange(let text, let callback):
                    PopupTitleChange(text: text,
                                     callback: callback)
                }
            }
        }
    }
}

//#Preview {
//    let manager = AppManager()
//    let navigation = TabNavigationViewModel()
//    @State var isShow = false
//    PopupView(isShow: $isShow, type: .watermarkTextSave)
//        .environmentObject(manager)
//        .environmentObject(navigation)
//}
