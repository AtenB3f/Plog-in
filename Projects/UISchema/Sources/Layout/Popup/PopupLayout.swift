//
//  PopupLayout.swift
//  UISchema
//
//  Created by AtenB on 4/30/26.
//

import SwiftUI

public protocol PopupLayout {
    var headerType: PopupHeaderLayout { get set }
    var contentType: PopupContentLayout { get set }
    var buttonType: PopupButtonLayout { get set }
    
    var header: any PopupHeader { get set }
    var content: any PopupContent { get set }
    var button: any PopupButton { get set }
}
