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
                switch type {
                case .melonStreaming:
                    Text("멜론에서 저장한 스트리밍 카드에 \n워터마크를 넣은 인증 이미지 만들기")
                        .font(.body1)
                        .foreground(.Text.dark)
                        .multilineTextAlignment(.leading)
                case .melonWeekly:
                    Text("주간 인기상 투표 화면을 캡쳐하여\n인증 이미지 만들기")
                        .font(.body1)
                        .foreground(.Text.dark)
                        .multilineTextAlignment(.leading)
                case .youtubeStreaming:
                    Text("영상의 시작과 끝 화면을 캡쳐한 두 장의 \n이미지를 합쳐 하나의 인증 이미지 만들기")
                        .font(.body1)
                        .foreground(.Text.dark)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.Shadow.light)
    }
}

#Preview {
    BasicWatermarkItemView(type: .melonStreaming)
    BasicWatermarkItemView(type: .melonWeekly)
    BasicWatermarkItemView(type: .youtubeStreaming)
}
