//
//  WatermarkManager.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//


//#Preview {
//    let manager = WatermarkManager()
//    var images: [Image] {
//        get {
//            if let pimage = PImage(systemName: "star") {
//                let result = manager.generateWatermarks(
//                    [pimage],
//                    watermark: .init(
//                        textSetting: .init(text: "plli",
//                                           fontName: FontType.body1.fontName,
//                                           fontSize: 10,
//                                           rotation: -20.0,
//                                           color: .red,
//                                           alpha: 1,
//                                           spacing: .init(width: 20, height: 20),
//                                           isGradient: true,
//                                           isDate: true),
//                        stickers: [],
//                        arraySetting: .init(type: .none, rows: 1, columns: 1),
//                        exportSetting: .init(type: .auto, size: .init(width: 200, height: 200)),
//                        frameSetting: .init(title: "Melon_Streaming", type: .basic)
//                    )
//                )
//                return result.compactMap{ Image(uiImage: $0) }
//            } else {
//                return []
//            }
//        }
//    }
//    
//    VStack {
//        ForEach(images.indices) {index in
//            images[index]
//                .resizable()
//                .frame(width: 300, height: 300, alignment: .center)
//        }
//    }
//}
