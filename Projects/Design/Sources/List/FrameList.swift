//
//  FrameList.swift
//  Design
//
//  Created by AtenB on 12/11/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore

public enum FrameListMode {
    case none
    case select
    case edit
    case sort
}

public struct FrameList: View {
    @Binding var mode: FrameListMode
    let list: [PImage]
    @Binding var select: Int?

    let onDelete: ((Int) -> Void)?
    let onMove: ((IndexSet, Int) -> Void)?

    @State private var sortList: [PImage] = []
    @State private var draggingItem: PImage?
    @GestureState private var dragOffset: CGSize = .zero
    private let spacing = 8.0
    private let size: Double

    @State private var sortDelayTimer: DispatchWorkItem?
    @State private var shouldStartSorting = false

    public init(
        mode: Binding<FrameListMode>,
        list: [PImage],
        select: Binding<Int?>,
        size: Double = 76,
        onDelete: ((Int) -> Void)? = nil,
        onMove: ((IndexSet, Int) -> Void)? = nil
    ) {
        self._mode = mode
        self.list = list
        self._select = select
        self.size = size
        self.onDelete = onDelete
        self.onMove = onMove
    }

    private var displayList: [PImage] { mode == .sort ? sortList : list }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(displayList.enumerated()), id: \.element) { index, item in
                    FrameListItemView(
                        image: item,
                        index: index,
                        mode: mode == .select ? (select == index ? .select : .none) : mode,
                        isDragging: draggingItem === item,
                        size: size,
                        onTap: {
                            handleTap(at: index)
                        },
                        onDelete: {
                            handleDelete(at: index)
                        },
                        onLongPress: {}
                    )
                    .animation(.easeInOut, value: index)
                    .offset(draggingItem === item ? dragOffset : .zero)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                handleSortStart(item: item)
                            }
                            .sequenced(before: DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    handleSorting(item: item, translation: value.translation)
                                }
                                .onEnded { _ in
                                    handleSortEnd()
                                }
                            )
                            .onEnded { value in
                                switch value {
                                case .second(true, _):
                                    handleSortEnd()
                                default:
                                    break
                                }
                            }
                    )
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            sortList = list
        }
        .onChange(of: list) {
            if mode != .sort {
                sortList = list
            }
        }
    }

    private func handleTap(at index: Int) {
        mode = .select
        select = index
    }

    private func handleDelete(at index: Int) {
        guard mode == .edit, index < list.count else { return }
        withAnimation {
            if select == index {
                select = nil
            } else if let selectedIndex = select, selectedIndex > index {
                select = selectedIndex - 1
            }
        }
        onDelete?(index)
    }

    private func handleSortStart(item: PImage) {
        guard mode == .none || mode == .sort else { return }
        sortList = list
        mode = .sort
        draggingItem = item
        select = nil
    }

    private func handleSorting(item: PImage, translation: CGSize) {
        let offset = translation.width
        guard mode == .sort, let dragIndex = sortList.firstIndex(where: { $0 === item }) else { return }

        if !shouldStartSorting {
            sortDelayTimer?.cancel()
            let workItem = DispatchWorkItem {
                self.shouldStartSorting = true
                self.sortDelayTimer = nil
                self.handleSorting(item: item, translation: translation)
            }
            sortDelayTimer = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: workItem)
            return
        }

        let itemWidth = size + spacing
        let estimatedCenterPosition = (CGFloat(dragIndex) * itemWidth) + (itemWidth / 2) + offset
        let newIndex = Int(round(estimatedCenterPosition / itemWidth)) - 1
        if newIndex >= 0 && newIndex < sortList.count && newIndex != dragIndex {
            sortList.move(
                fromOffsets: IndexSet(integer: dragIndex),
                toOffset: newIndex > dragIndex ? newIndex + 1 : newIndex
            )
        }
    }

    private func handleSortEnd() {
        sortDelayTimer?.cancel()
        sortDelayTimer = nil
        shouldStartSorting = false

        if let draggingItem,
           let fromIndex = list.firstIndex(where: { $0 === draggingItem }),
           let toIndex = sortList.firstIndex(where: { $0 === draggingItem }),
           fromIndex != toIndex {
            let toOffset = toIndex > fromIndex ? toIndex + 1 : toIndex
            onMove?(IndexSet(integer: fromIndex), toOffset)
        }

        withAnimation {
            draggingItem = nil
        }
    }
}
