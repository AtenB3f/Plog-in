//
//  Gradient.swift
//  Design
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public extension Gradient {
    static let plave: Gradient = .init(colors: Color.disablePrimarys.map{ $0.opacity(0.3) })
    
    static let deep: Gradient = .init(colors: [.clear, Color("Gradient/Deep", bundle: .module)])
    static let shallow: Gradient = .init(colors: [.clear, Color("Gradient/Shallow", bundle: .module)])
    static let light: Gradient = .init(colors: [.clear, Color("Gradient/Light", bundle: .module)])
}

#Preview {
    ZStack {
        Color.black
        LinearGradient(gradient: .light, startPoint: .top, endPoint: .bottom)
    }
}
