//
//  WatermarkMapper.swift
//  Persistence
//
//  Created by AtenB on 4/2/26.
//

import Foundation
import WatermarkDomain

// MARK: - Word Entity -> Model
public extension WatermarkWordEntity {
    var toModel: WatermarkWordModel {
        return .init(text: self.text)
    }
}

public extension WatermarkWordModel {
    var toEntity: WatermarkWordEntity {
        return .init(text: self.text)
    }
}

// MARK: - Watermark Model -> Entity
public extension WatermarkModel {
    var toEntity: WatermarkEntity {
        return .init(
            textSetting: self.text.toEntity,
            stickers: self.stickers.map { $0.toEntity },
            arraySetting: self.array.toEntity,
            exportSetting: self.export.toEntity,
            frameSetting: self.frame.toEntity
        )
    }
}

public extension WatermarkEntity {
    var toModel: WatermarkModel {
        return .init(
//            id: self.id,
            text: self.textSetting.toModel,
            stickers: self.stickers.map { $0.toModel },
            array: self.arraySetting.toModel,
            export: self.exportSetting.toModel,
            frame: self.frameSetting.toModel
        )
    }
}
public extension WatermarkTextModel {
    var toEntity: WatermarkTextEntity {
        return .init(
            text: self.text,
            fontName: self.fontName,
            fontSize: self.fontSize,
            rotation: self.rotation,
            color: self.color,
            spacingWidth: self.spacingWidth,
            spacingHeight: self.spacingHeight,
            isGradient: self.isGradient,
            isDate: self.isDate
        )
    }
}

public extension WatermarkTextEntity {
    var toModel: WatermarkTextModel {
        return .init(
            text: self.text,
            fontName: self.fontName,
            fontSize: self.fontSize,
            rotation: self.rotation,
            color: self.color,
            spacingWidth: self.spacingWidth,
            spacingHeight: self.spacingHeight,
            isGradient: self.isGradient,
            isDate: self.isDate
        )
    }
}
public extension WatermarkStickerModel {
    var toEntity: WatermarkStickerEntity {
        return .init(
            image: self.imageData,
            alpha: self.alpha,
            position: self.position,
            rotation: self.rotation,
            scale: self.scale,
            layer: self.layer
        )
    }
}

public extension WatermarkStickerEntity {
    var toModel: WatermarkStickerModel {
        return .init(
            image: self.imageData,
            alpha: self.alpha,
            position: self.position,
            rotation: self.rotation,
            scale: self.scale,
            layer: self.layer
        )
    }
}

public extension WatermarkArrayModel {
    var toEntity: WatermarkArrayEntity {
        return .init(
            type: self.type,
            rows: self.rows,
            columns: self.columns
        )
    }
}

public extension WatermarkArrayEntity {
    var toModel: WatermarkArrayModel {
        return .init(
            type: self.type,
            rows: self.rows,
            columns: self.columns
        )
    }
}

public extension WatermarkExportModel {
    var toEntity: WatermarkExportEntity {
        return .init(
            type: self.type,
            size: .init(width: self.width, height: self.height),
            multiple: self.multiple
        )
    }
}

public extension WatermarkExportEntity {
    var toModel: WatermarkExportModel {
        return .init(
            type: self.type,
            width: self.width,
            height: self.height,
            multiple: self.multiple
        )
    }
}

public extension WatermarkFrameModel {
    var toEntity: WatermarkFrameEntity {
        return .init(
            thumnail: self.thumnailData,
            title: self.title,
            type: self.type
        )
    }
}

public extension WatermarkFrameEntity {
    var toModel: WatermarkFrameModel {
        return .init(
            thumnail: self.thumnailData,
            title: self.title,
            type: self.type
        )
    }
}
