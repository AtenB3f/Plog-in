//
//  WatermarkFormatDisplayTextTests.swift
//  WatermarkDomainTests
//

import Foundation
import Testing
@testable import WatermarkDomain

@Suite("WatermarkFormat.getDisplayText")
struct GetDisplayTextTests {
    let format = WatermarkFormat()

    @Test("date가 없으면 원문 그대로 반환")
    func noDate() {
        let text = WatermarkTextModel(text: "TEST", date: nil)
        #expect(format.getDisplayText(for: text) == "TEST")
    }

    @Test("date가 있는 경우 yyyy-MM-dd 형식으로 표기")
    func withDate() {
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 5
        let date = Calendar.current.date(from: components)!

        let text = WatermarkTextModel(text: "TEST", date: date)
        #expect(format.getDisplayText(for: text) == "TEST 2024-03-05")
    }
}
