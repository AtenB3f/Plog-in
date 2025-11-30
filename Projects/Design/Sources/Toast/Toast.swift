//
//  Toast.swift
//  Design
//
//  Created by AtenB on 11/14/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct ToastData {
    public enum IconType {
        case spinner
        case check
    }
    
    let type: IconType?
    let text: String
    let button: String?
    
    public init(
        text: String,
        type: IconType? = nil,
        button: String? = nil
    ) {
        self.text = text
        self.type = type
        self.button = button
    }
}

public struct Toast: View {
    let data: ToastData
    let callback: (()->Void)?
    
    public init(
        _ data: ToastData,
        callback: (()->Void)? = nil
    ) {
        self.data = data
        self.callback = callback
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 6) {
            if let type = data.type {
                switch type {
                case .spinner:
                    Spinner(.Text.light, 1.5)
                        .frame(width: 16, height: 16)
                        .padding(4)
                case .check:
                    Image(.checkSM)
                        .resizable()
                        .renderingMode(.template)
                        .foreground(.Text.light)
                        .frame(width: 24, height: 24)
                }
            }
            
            Text(data.text)
                .font(.body1)
                .foreground(.Text.medium)
            
            if let button = data.button {
                Button {
                    callback?()
                } label: {
                    HStack(spacing: 0) {
                        Text(button)
                            .font(.bold1)
                            .foreground(.Text.light)
                        Image(.chevronRightSM)
                            .resizable()
                            .renderingMode(.template)
                            .foreground(.Text.light)
                            .frame(width: 18, height: 18)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.Base.medium)
        .cornerRadius(4, corner: .all)
        .shadow(.disable)
    }
}

#Preview {
    Toast(
        .init(
        text: "앱을 닫으면 이미지 생성이 완료되지 않습니다.",
        type: .check, button: "앨범 이동"), callback: {
            
        }
    )
}
