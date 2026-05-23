//
//  PopupView.swift
//  Plogin
//
//  Created by AtenB on 5/9/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI

public struct PopupView: View {
    
    public init(
    ) {
    }
    
    public var body: some View {
        ZStack {
            Color.Shadow.medium
                .ignoresSafeArea()
            
            Group {
                makePopup()
            }
            .padding(.horizontal, 30)
        }
    }
    
    @ViewBuilder
    func makePopup() -> some View {
        EmptyView()
    }
}
