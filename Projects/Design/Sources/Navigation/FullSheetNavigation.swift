//
//  FullSheetNavigation.swift
//  Design
//
//  Created by AtenB on 4/11/25.
//

import SwiftUI

#if os(iOS)
@available(iOS 14.0, *)
public struct FullSheetLayout<Content>: View where Content: View {
    var content: Content
    var backgoundColor: Color
    public init(_ color: Color = .white,
                @ViewBuilder content: () -> Content) {
        self.backgoundColor = color
        self.content = content()
    }

    public var body: some View {
        ZStack {
            backgoundColor.ignoresSafeArea()
            content
        }
        .navigationBarHidden(true)
    }
}
#endif

//#Preview {
//    FullSheetLayout(.blue,
//                    content: {
//        VStack {
//            Text("asdf")
//        }
//        .frame(width: 100, height: 300, alignment: .center)
//        .background(Color.white)
//    })
//}
