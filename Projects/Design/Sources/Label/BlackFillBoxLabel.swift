//
//  BlackFillBoxLabel.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct BlackFillBoxLabel: View {
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            Text(text)
                .font(.bold2)
                .foreground(.Text.light)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(6)
    }
}

//#Preview {
//    ZStack {
//        Color.Base.dark
//        BlackFillBoxLabel("다음")
//    }
//}
