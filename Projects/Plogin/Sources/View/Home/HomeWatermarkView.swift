//
//  HomeWatermarkView.swift
//  Plogin
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct HomeWatermarkView: View {
    @StateObject var manager = AppManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("워터마크 생성기")
                .font(.header1)
                .foreground(.Text.light)
                .padding(.bottom, 4)
            
            Text("스트리밍 인증을 위한 나만의 워터마크 프레임")
                .font(.body3)
                .foreground(.Text.dark)
                .padding(.bottom, 28)
            
            Button {
                manager.push(.watermark)
            } label: {
                IconLabel(text: "새로 만들기", icon: .iconChevronRightSM, color: .white, size: 24)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
            }
            .iconLabelButtonStyle()
        }
        .padding(16)
    }
}
