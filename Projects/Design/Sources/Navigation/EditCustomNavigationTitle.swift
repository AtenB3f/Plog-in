//
//  EditCustomNavigationTitle.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

/// 왼쪽에는 x 버튼, 오른쪽은 다운로드 버튼이 있는 네비게이션 타이틀 뷰
/// 타이틀은 버튼이며, 오른쪽에 꺽쇠 아이콘이 있음
/// - Parameters
///   - title: 제목이 최대 표기보다 긴 경우 ...가 됨
///   - callback : 닫기/다운로드 버튼 클릭 콜백
///      left : false | right : true
///   - titleCallback: 타이틀 클릭 콜백
public struct EditCustomNavigationTitle: View {
    @Binding var title: String
    var callback: ((Bool)->Void)
    var titleCallback: (()->Void)
    
    public init(
        title: Binding<String>,
        callback: @escaping (Bool) -> Void,
        titleCallback: @escaping () -> Void
    ) {
        self._title = title
        self.callback = callback
        self.titleCallback = titleCallback
    }
    
    public var body: some View {
        HStack {
            Button {
                callback(false)
            } label: {
                Image.iconCloseMD
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                    .foreground(.white)
                    .padding(10)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                titleCallback()
            } label: {
                HStack(spacing: 0) {
                    Text(String(title))
                        .bold4()
                        .foreground(.white)
                        .lineLimit(1)
                        
                    
                    Image.iconChevronRightSM
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                        .foreground(.white)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                callback(true)
            } label: {
                Image.iconDownloadPackage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                    .foreground(.white)
                    .padding(10)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 6)
        .background(Color.black)
    }
}

#Preview {
    @State var title: String = "제목없제목없음제목없음제목없음"
    EditCustomNavigationTitle(title: $title, callback: { _ in
        
    }, titleCallback: {
        
    })
    EditNavigationTitle(title: $title, callback: { _ in
        
    })
}
