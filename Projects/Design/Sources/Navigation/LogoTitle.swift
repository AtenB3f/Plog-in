//
//  LogoTitle.swift
//  Plogin
//
//  Created by AtenB on 11/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct LogoTitle: View {
    public init() {}
    public var body: some View {
        HStack {
            Image("Logo_Image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black)
    }
}
