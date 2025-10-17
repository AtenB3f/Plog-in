//
//  Text+.swift
//  Design
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public extension Text {
    func header1() -> some View {
        let type = FontType.header1
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func header2() -> some View {
        let type = FontType.header2
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func header3() -> some View {
        let type = FontType.header3
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func sub1() -> some View {
        let type = FontType.sub1
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func sub2() -> some View {
        let type = FontType.sub2
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func sub3() -> some View {
        let type = FontType.sub3
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func body1() -> some View {
        let type = FontType.body1
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func body2() -> some View {
        let type = FontType.body2
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func body3() -> some View {
        let type = FontType.body3
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func body4() -> some View {
        let type = FontType.body4
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func bold1() -> some View {
        let type = FontType.bold1
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func bold2() -> some View {
        let type = FontType.bold2
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func bold3() -> some View {
        let type = FontType.bold3
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func bold4() -> some View {
        let type = FontType.bold4
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
    
    func caption() -> some View {
        let type = FontType.caption
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
}
