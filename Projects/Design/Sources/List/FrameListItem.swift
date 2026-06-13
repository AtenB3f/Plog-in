//
//  FrameListItem.swift
//  Design
//
//  Created by AtenB on 12/15/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore

public struct FrameListItemView: View {
    let image: PImage
    let index: Int
    let mode: FrameListMode
    let isDragging: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    let size: Double

    init(
        image: PImage,
        index: Int,
        mode: FrameListMode,
        isDragging: Bool,
        size: Double,
        onTap: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onLongPress: @escaping () -> Void
    ) {
        self.image = image
        self.index = index
        self.mode = mode
        self.isDragging = isDragging
        self.size = size
        self.onTap = onTap
        self.onDelete = onDelete
        self.onLongPress = onLongPress
    }

    public var body: some View {
        RoundedCorner(radius: 4, corner: .all)
            .frame(width: size, height: size)
            .foreground(Color.Base.medium)
            .scaleEffect(isDragging ? 0.7 : 1.0)
            .overlay(alignment: .topTrailing) {
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

                        if isDragging { Color.Shadow.disable }
                    }
                    if mode == .select {
                        RoundedCorner(radius: 4, corner: .all)
                            .stroke()
                            .foreground(.Text.light)
                    }
                }
                .cornerRadius(4, corner: .all)
                .scaleEffect(isDragging ? 0.7 : 1.0)
                .transition(.opacity)
            }
        .onTapGesture {
            onTap()
        }
    }
}
