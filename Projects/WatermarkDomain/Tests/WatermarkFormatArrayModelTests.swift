//
//  WatermarkFormatArrayModelTests.swift
//  WatermarkDomainTests
//

import Testing
import PlatformCore
@testable import WatermarkDomain

@Suite("WatermarkFormat.makeArrayModel")
struct MakeArrayModelTests {
    let format = WatermarkFormat()

    @Test(
        "배치 타입별로 rows/columns가 어떻게 재계산되는지",
        arguments: [
            (WatermarkArrayType.none, 1, 1),
            (WatermarkArrayType.horizontal, 1, 4),
            (WatermarkArrayType.vertical, 4, 1),
            (WatermarkArrayType.grid, 1, 1),
        ]
    )
    func recalculatesRowsColumns(type: WatermarkArrayType, expectedRows: Int, expectedColumns: Int) {
        let images = Array(repeating: PImage.testFixture(width: 100, height: 100), count: 4)
        let current = WatermarkArrayModel(type: .none, rows: 9, columns: 9)

        let result = format.makeArrayModel(origins: images, type: type, current: current)

        #expect(result.type == type)
        #expect(result.rows == expectedRows)
        #expect(result.columns == expectedColumns)
    }
}
