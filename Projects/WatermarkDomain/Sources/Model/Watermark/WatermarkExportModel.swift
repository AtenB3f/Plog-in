//
//  WatermarkExportModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

public enum WatermarkExportType: String, Codable, CaseIterable {
    case auto
    case multifple
    
    public var menuName: String {
        switch self {
        case .auto:
            return "auto"
        case .multifple:
            return "배수"
        }
    }
}

public struct WatermarkExportModel {
    public var type: WatermarkExportType
    public var width: CGFloat
    public var height: CGFloat
    public var multiple: CGFloat
    
    public init(
        type: WatermarkExportType = .auto,
        width: CGFloat = .zero,
        height: CGFloat = .zero,
        multiple: CGFloat = 1
    ) {
        self.type = type
        self.width = width
        self.height = height
        self.multiple = multiple
    }
}

public extension WatermarkExportModel {
    func getSize() -> CGSize {
        return .init(width: self.width*multiple, height: self.height*multiple)
    }
    
    // View 출력 용
    func getSizeStr() -> String {
        return "\(Int(width*multiple)) × \(Int(height*multiple))"
    }
}
