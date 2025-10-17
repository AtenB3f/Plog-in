//
//  Font.swift
//  Design
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public enum FontType: CaseIterable {
    case header1
    case header2
    case header3
    case sub1
    case sub2
    case sub3
    case body1
    case body2
    case body3
    case body4
    case bold1
    case bold2
    case bold3
    case bold4
    case caption
    
    public var fontName: String {
        switch self {
        case .header1, .header2, .header3:
            return "Pretendard-Bold"
        case .sub1, .bold1, .bold2, .bold3, .bold4:
            return "Pretendard-SemiBold"
        default:
            return "Pretendard-Regular"
        }
    }
    
    public var size: CGFloat {
        switch self {
        case .header1:
            return 24
        case .header2:
            return 28
        case .header3:
            return 36
        case .sub1:
            return 18
        case .sub2:
            return 22
        case .sub3:
            return 24
        case .body1, .bold1:
            return 13
        case .body2, .bold2:
            return 14
        case .body3, .bold3:
            return 15
        case .body4, .bold4:
            return 16
        case .caption:
            return 12
        }
    }
    
    public var lineHeight: CGFloat {
        switch self {
        case .header1:
            return 32
        case .header2:
            return 38
        case .header3:
            return 48
        case .sub1:
            return 26
        case .sub2:
            return 30
        case .sub3:
            return 30
        case .body1, .bold1:
            return 18
        case .body2, .bold2:
            return 20
        case .body3, .bold3:
            return 22
        case .body4, .bold4:
            return 22
        case .caption:
            return 16
        }
    }
    
    public var font: Font {
        return .custom(fontName, size: size)
    }
}

public class FontLoader {
    public static func loadModuleFont() {
        let fonts = FontType.allCases
        guard let urls = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: nil) else { return }

        for font in fonts {
            if let url = urls.first(where: { $0.lastPathComponent.contains(font.fontName) }) {
                loadFont(url)
            }
        }
    }

    public static func loadModuleFont(_ urls: [URL]) {
        for url in urls {
            loadFont(url)
        }
    }

    public static func loadFont(_ url: URL) {
        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
            print("[Design] registered \(url.lastPathComponent)")
        } else {
            print("[Design] unable to register font: \(error!.takeUnretainedValue())")
        }
    }
}
