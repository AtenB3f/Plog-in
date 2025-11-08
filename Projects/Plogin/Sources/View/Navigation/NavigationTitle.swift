//
//  NavigationTitle.swift
//  Plogin
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

struct NavigationTitle: View {
    var body: some View {
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

//#Preview {
//    NavigationTitle()
//}
