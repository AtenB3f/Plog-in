//
//  CategoryTabbar.swift
//  Design
//
//  Created by AtenB on 10/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//
import SwiftUI
import SwiftUI

public struct CategoryTabbar: View {
    public init(
        index: Binding<Int>,
        list: [String]) {
        self._index = index
        self.list = list
    }
    
    @Binding var index: Int
    let list: [String]
    
    @State private var tabFrames: [Int: CGRect] = [:]
    private let lineColors: [Color] = [.Yejun.main, .Noah.main, .Bamby.main, .Eunho.main, .Hamin.main]
    private let backgroundColors: [Color] = [.Yejun.disable, .Noah.disable, .Bamby.disable, .Eunho.disable, .Hamin.disable]
    
    public var body: some View {
        ZStack(alignment: .leading) {
            if let frame = tabFrames[index] {
                RoundedCorner(radius: 15, corner: .all)
                    .fill(backgroundColors[index%5])
                    .frame(width: frame.width, height: frame.height)
                    .offset(x: frame.minX, y: frame.minY)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: index)
                
                RoundedCorner(radius: 15, corner: .all)
                    .stroke()
                    .foreground(lineColors[index%5])
                    .frame(width: frame.width, height: frame.height)
                    .offset(x: frame.minX, y: frame.minY)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: index)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(list.indices, id: \.self) { item in
                        Button {
                            withAnimation {
                                index = item
                            }
                        } label: {
                            Text(list[item])
                                .font(.body2)
                                .foreground(index == item ? .white : .Text.dark)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        tabFrames[item] = geo.frame(in: .named("TabbarSpace"))
                                    }
                                    .onChange(of: geo.frame(in: .named("TabbarSpace"))) { oldValue, newValue in
                                        tabFrames[item] = newValue
                                    }
                            }
                        )
                    }
                }
            }
        }
        .coordinateSpace(name: "TabbarSpace")
    }
}
// PreferenceKey 정의
struct TabFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let next = nextValue()
        if next != .zero {
            value = next
        }
    }
}

//#Preview {
//    @State var index: Int = 0
//    CategoryTabbar(index: $index, list: ["텍스트", "스티커", "배열", "출력" ,"프레임"])
//}
