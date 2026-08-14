//
//  FrameListItem.swift
//  Design
//
//  Created by AtenB on 12/15/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore
import UniformTypeIdentifiers

public struct FrameItemState: Codable {
    public var id: UUID
    public var data: Data
    public var image: PImage { PImage(data: data) ?? PImage() }
    
    public init(
        id: UUID = UUID(),
        image: PImage
    ) {
        self.id = id
        self.data = image.pngData() ?? Data()
    }
    
    public init(
        id: UUID = UUID(),
        data: Data
    ) {
        self.id = id
        self.data = data
    }
}

extension FrameItemState: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .data) { item in
            let transfer = FrameItemState(
                id: item.id,
                image: item.image
            )
            return try JSONEncoder().encode(transfer)
        } importing: { data in
            let transfer = try JSONDecoder().decode(FrameItemState.self, from: data)
            return FrameItemState(
                id: transfer.id,
                image: PImage(data: transfer.data) ?? PImage()
            )
        }
    }
}

public struct FrameItemView: View {
    let image: PImage
    let index: Int
    let mode: FrameListMode
    let onDelete: () -> Void
    let size: Double

    init(
        image: PImage,
        index: Int,
        mode: FrameListMode,
        size: Double,
        onDelete: @escaping () -> Void
    ) {
        self.image = image
        self.index = index
        self.mode = mode
        self.size = size
        self.onDelete = onDelete
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(pImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            LinearGradient(gradient: .shallow, startPoint: .bottom, endPoint: .top)
                .frame(height: 24)
                .opacity((mode == .edit || mode == .sort) ? 1.0 : .zero)

            if mode == .edit {
                Button(action: onDelete) {
                    Image.iconCloseSM
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                        .foreground(.Text.light)
                }
            }
            if mode == .sort {
                Image.iconMenuDuo
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                    .foreground(.Text.light)
            }
            if mode == .select {
                RoundedCorner(radius: 4, corner: .all)
                    .stroke()
                    .foreground(.Text.light)
            }
        }
        .frame(width: size, height: size)
        .background(Color.Base.medium)
        .cornerRadius(4, corner: .all)
    }
}
