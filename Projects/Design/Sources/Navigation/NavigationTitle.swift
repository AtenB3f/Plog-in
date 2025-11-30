//
//  NavigationTitle.swift
//  Plogin
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct NavigationTitle: View {
    let title: String
    let leftIcon: Image?
    let rightIcon: Image?
    let callback: (Bool)->Void
    
    public init(
        title: String,
        leftIcon: Image? = .iconPrev,
        rightIcon: Image? = nil,
        callback: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.callback = callback
    }
    
    public var body: some View {
        HStack {
            if let leftIcon = leftIcon {
                Button {
                    callback(false)
                } label: {
                    leftIcon
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foreground(.white)
                        .frame(width: 24, height: 24)
                        .padding()
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(title)
                .font(.bold4)
                .foreground(.white)
            
            Spacer()
            
            if let rightIcon = rightIcon {
                Button {
                    callback(true)
                } label: {
                    rightIcon
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foreground(.white)
                        .frame(width: 24, height: 24)
                        .padding()
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    NavigationTitle()
//}
