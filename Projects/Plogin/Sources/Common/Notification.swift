//
//  Notification.swift
//  Plogin
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let splashEndDelay = Notification.Name(rawValue: "Splash_End_Delay")
    
    static let logout = Notification.Name(rawValue: "Logout")
    
    static let pushPopup = Notification.Name(rawValue: "Push_Popup")
    
    static let scrollTo = Notification.Name(rawValue: "Scroll_To")
}
