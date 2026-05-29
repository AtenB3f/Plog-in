//
//  Date+.swift
//  Design
//
//  Created by AtenB on 11/13/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public extension Date {
    var yearsFromNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    var monthsFromNow: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month!
    }
    var weeksFromNow: Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear!
    }
    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var hoursFromNow: Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
    }
    var minutesFromNow: Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
    }
    var secondsFromNow: Int {
        return Calendar.current.dateComponents([.second], from: self, to: Date()).second!
    }

    /// Format: yyyy-MM-dd
    static func now() -> String {
        var calendar = Calendar.current
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: Date())
    }
    
    func now() -> String {
        var calendar = Calendar.current
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self)
    }
}
