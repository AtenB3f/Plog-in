//
//  GridSelector.swift
//  Design
//
//  Created by AtenB on 12/1/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct GridSelector: View {
    @Binding var rows: Int
    @Binding var columns: Int
    @State private var selectRow: Int
    @State private var selectColumn: Int
    @State private var isDragging = false
    @State private var tempRows: Int = 1
    @State private var tempColumns: Int = 1
    
    let maxRow: Int
    let minRow: Int = 1
    let maxColumn: Int
    let minColumn: Int = 1
    let spacing: CGFloat
    let cellSize: CGFloat
    
    public init(
        rows: Binding<Int>,
        columns: Binding<Int>,
        maxRow: Int = 6,
        maxColumn: Int = 6,
        cellSize: CGFloat = 24,
        spacing: CGFloat = 4
    ) {
        self._rows = rows
        self._columns = columns
        self.selectRow = rows.wrappedValue
        self.selectColumn = columns.wrappedValue
        self.maxRow = maxRow
        self.maxColumn = maxColumn
        self.cellSize = cellSize
        self.spacing = spacing
    }
    
    public var body: some View {
        Grid(horizontalSpacing: spacing, verticalSpacing: 4) {
            ForEach(0..<maxColumn, id:\.self) { col in
                GridRow {
                    ForEach(0..<maxRow, id:\.self) { row in
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 20, height: 20)
                            .foreground((selectRow > row && selectColumn > col) ? .Gray.light : .Gray.disable)
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { drag in
                    let location = drag.location
                    handleDrag(x: location.x, y: location.y)
                }
                .onEnded { _ in
                    columns = selectColumn
                    rows = selectRow
                }
        )
    }
    
    func handleDrag(x: CGFloat, y: CGFloat) {
        if x < 0 {
            selectRow = 1
        } else {
            let row = Int(x/(cellSize+(spacing/2))) + 1
            selectRow = min(row, maxRow)
        }
        if y < 0 {
            selectColumn = 1
        } else {
            let column = Int(y/(cellSize+(spacing/2))) + 1
            selectColumn = min(column, maxColumn)
        }
    }
}


#Preview {
    @State var rows: Int = 1
    @State var columns: Int = 1
    GridSelector(rows: $rows, columns: $columns)
}
