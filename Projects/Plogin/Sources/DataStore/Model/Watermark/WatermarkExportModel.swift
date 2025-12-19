//
//  WatermarkExportModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import SwiftData

enum WatermarkExportType: String, Codable, CaseIterable {
    case auto
    case multifple
    
    var menuName: String {
        switch self {
        case .auto:
            return "auto"
        case .multifple:
            return "배수"
        }
    }
}

@Model
public final class WatermarkExportModel {
    var type: WatermarkExportType
    var width: CGFloat
    var height: CGFloat
    var multiple: CGFloat
    
    var watermark: WatermarkModel?
    
    init(type: WatermarkExportType = .auto, size: CGSize = .zero, multiple: CGFloat = 1) {
        self.type = type
        self.width = size.width
        self.height = size.height
        self.multiple = multiple
    }
}

extension WatermarkExportModel {
    func getSize() -> CGSize {
        return .init(width: self.width*multiple, height: self.height*multiple)
    }
    
    func getSizeStr() -> String {
        return "\(Int(width*multiple)) × \(Int(height*multiple))"
    }
}
