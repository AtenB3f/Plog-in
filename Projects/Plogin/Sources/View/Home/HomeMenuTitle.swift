//
//  HomeMenuTitle.swift
//  Plogin
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct HomeMenuTitle: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .body1()
                .foreground(.Text.medium)
                .padding(.horizontal, 6)
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .background(Color.Base.dark)
    }
}

#Preview {
    HomeMenuTitle(title: "기본 프레임")
}
