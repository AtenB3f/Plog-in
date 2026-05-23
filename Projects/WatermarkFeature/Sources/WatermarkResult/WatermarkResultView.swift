//
//  WatermarkResultView.swift
//  Plogin
//
//  Created by AtenB on 1/6/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore

struct WatermarkResultView: View {
    @Environment(\.dismiss) var dismiss
//    private let manager = AppManager.shared
//    private let editor = WatermarkManager()
    
    let results: [PImage]
    
    @State var page: Int = 0
    @State private var failCount: Int = 0
    @State private var isShowIndicator: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitle(
                title: "미리보기",
                leftIcon: .iconChevronLeftSM,
                rightIcon: .iconSave, callback: { isRight in
                if isRight {
                    clickSave()
                } else {
                    dismiss()
                }
            })
            
            TabView(selection: $page) {
                ForEach(results, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page)
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
        .overlay {
            if isShowIndicator {
                SkeletonView()
            }
        }
    }
    
    func clickSave() {
//        Task {
//            isShowIndicator = true
//            async let save: () = saveImageToLibrary()
//            async let sleep: () = Task.sleep(for: .seconds(3))
//            _ = try await (save, sleep)
//            isShowIndicator = false
//            try? await Task.sleep(for: .milliseconds(300))
//            manager.pushRoot()
//        }
    }
    
//    func saveImageToLibrary() async {
//        for i in 0..<results.count {
//            if let isSuccess = try? await editor.saveImageToPhotoLibrary(image: results[i]) {
//                if !isSuccess { failCount += 1 }
//            }
//        }
//    }
}
