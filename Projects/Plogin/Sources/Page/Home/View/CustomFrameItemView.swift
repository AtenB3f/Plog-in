//
//  CustomFrameItemView.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore

public struct HomeCustomFrameViewState: Identifiable {
    public var id: UUID
    public var title: String
    public var thumbnail: PImage
}

struct CustomFrameItemView: View {
    let data: HomeCustomFrameViewState
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.Shadow.dark
            Image(pImage: data.thumbnail)
            
            Text(data.title)
                .font(.bold2)
                .foreground(.Text.light)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top)
                .background(LinearGradient(gradient: .shallow, startPoint: .top, endPoint: .bottom))
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CustomFrameItemView(data: .init(id: UUID(), title: "제목없음", thumbnail: PImage()))
}
