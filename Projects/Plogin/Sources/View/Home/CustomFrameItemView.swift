//
//  CustomFrameItemView.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct CustomFrameItemView: View {
    let title: String = "주간 인기상"
    let thumbnail: Image = Image("Logo_Name")
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.Shadow.dark
            thumbnail
            
            Text(title)
                .bold2()
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
    CustomFrameItemView()
}
