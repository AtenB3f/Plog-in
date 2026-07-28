//
//  PreviewWatermarkText.swift
//  WatermarkPreviewSupport
//

#if DEBUG
import Foundation
import Design
import PlatformCore
import PlatformExport
import WatermarkDomain

public func makePreviewWatermarkText(
    picker: AssetPicker,
    array: WatermarkArrayModel,
    text: String = "test"
) -> WatermarkTextModel {
    FontLoader.loadModuleFont()

    var textModel = WatermarkTextModel(
        text: text,
        fontName: FontType.body1.fontName,
        rotation: -20,
        color: ColorData(.black),
        spacingWidthRatio: 0.3,
        spacingHeightRatio: 1.0,
        date: Date()
    )
    WatermarkFormat().makeTextModel(
        origins: picker.images,
        array: array,
        current: &textModel
    )
    return textModel
}
#endif
