//
//  BasicWatermarkFrameItemView.swift
//  Plogin
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import WatermarkDomain

struct BasicWatermarkItemView: View {
    let type: BasicWatermarkType
    var body: some View {
        HStack(spacing: 30) {
            Image(type.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 68)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type.title)
                    .font(.sub1)
                    .foreground(.Text.light)
                
                Text(type.description)
                    .font(.body1)
                    .foreground(.Text.dark)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.Shadow.light)
    }
}

//#Preview {
//    BasicWatermarkItemView(type: .melonStreaming)
//    BasicWatermarkItemView(type: .melonWeekly)
//    BasicWatermarkItemView(type: .youtubeStreaming)
//}
