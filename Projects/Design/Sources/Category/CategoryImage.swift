//
//  CategoryImage.swift
//  Plogin
//
//  Created by AtenB on 12/3/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore

public enum CategoryImageMode {
    case select
    case edit
    case order
}

public struct CategoryImage: View {
    @Binding var mode: CategoryImageMode?
    let image: Image
    let callback: (CategoryImageMode) -> Void
    
    public init(
        mode: Binding<CategoryImageMode?>,
        image: Image,
        callback: @escaping (CategoryImageMode) -> Void
    ) {
        self._mode = mode
        self.image = image
        self.callback = callback
    }
    
    public var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 76, height: 76)
            .overlay(alignment: .topTrailing) {
                if let mode = mode {
                    switch mode {
                    case .select:
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                            .foreground(.Text.light)
                    case .edit:
                        ZStack(alignment: .topTrailing) {
                            LinearGradient(gradient: .shallow, startPoint: .bottom, endPoint: .top)
                                .frame(height: 24)
                                .frame(width: .infinity)
                            Button {
                                callback(mode)
                            } label: {
                                Image.iconCloseSM
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foreground(.Text.light)
                            }
                        }
                    case .order:
                        Button {
                            callback(mode)
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                LinearGradient(gradient: .shallow, startPoint: .bottom, endPoint: .top)
                                    .frame(height: 24)
                                    .frame(width: .infinity)
                                Image.iconMenuDuo
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foreground(.Text.light)
                            }
                        }
                    }
                }
            }
            .cornerRadius(4, corner: .all)
    }
}

//#Preview {
//    @Previewable @State var mode: CategoryImageMode? = .order
//    let image = Image(systemName: "star.fill")
//    CategoryImageItemView(mode: $mode, image: image, callback: { _ in
//        
//    })
//}
