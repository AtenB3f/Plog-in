//
//  FrameList.swift
//  Design
//
//  Created by AtenB on 12/11/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public enum FrameListMode {
    case none
    case select
    case edit
    case sort
}

public protocol TitleImagable: Identifiable, Equatable {
    var image: PImage? { get }
    var title: String? { get }
    var size: CGFloat { get }
}

public struct FrameList<T: TitleImagable>: View {
    @Binding var mode: FrameListMode
    @Binding var list: [T]
    @Binding var select: Int?
    
    @State private var draggingItem: T?
    @GestureState private var dragOffset: CGSize = .zero
    private let spacing = 8.0
    
    @State private var sortDelayTimer: DispatchWorkItem?
    @State private var shouldStartSorting = false
    
    public init(
        mode: Binding<FrameListMode>,
        list: Binding<[T]>,
        select: Binding<Int?>
    ) {
        self._mode = mode
        self._list = list
        self._select = select
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(list.enumerated()), id: \.element.id) { index, item in
                    FrameListItemView(
                        item: item,
                        index: index,
                        mode: select == index ? .select : .none,
                        isDragging: draggingItem?.id == item.id,
                        onTap: {
                            handleTap(at: index)
                        },
                        onDelete: {
                            handleDelete(at: index)
                        },
                        onLongPress: {
//                            handleLongPress(item: item)
                        }
                    )
                    .animation(.easeInOut, value: index)
                    .offset(draggingItem?.id == item.id ? dragOffset : .zero)
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
    }
    
    private func handleTap(at index: Int) {
        mode = .select
        select = index
    }
    
    private func handleDelete(at index: Int) {
        guard mode == .edit, index < list.count else { return }
        withAnimation {
            list.remove(at: index)
            if select == index {
                select = nil
            } else if let selectedIndex = select, selectedIndex > index {
                select = selectedIndex - 1
            }
        }
    }
    
    private func handleSortStart(item: T) {
         guard mode == .none || mode == .sort else { return }
         mode = .sort
         draggingItem = item
         select = nil
    }
    
    private func handleSorting(item: T, translation: CGSize) {
        let offset = translation.width
        guard mode == .sort, let dragIndex = list.firstIndex(where: { $0.id == item.id }) else { return }
        
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
        
        let itemWidth = item.size + spacing
        let estimatedCenterPosition = (CGFloat(dragIndex) * itemWidth) + (itemWidth / 2) + offset
        let newIndex = Int(round(estimatedCenterPosition / itemWidth)) - 1
        if newIndex >= 0 && newIndex < list.count && newIndex != dragIndex {
            let new = newIndex > dragIndex ? newIndex + 1 : newIndex
            list.move(fromOffsets: IndexSet(integer: dragIndex), toOffset: newIndex > dragIndex ? newIndex + 1 : newIndex)
        }
    }
    
    private func handleSortEnd() {
        sortDelayTimer?.cancel()
        sortDelayTimer = nil
        
        shouldStartSorting = false
        withAnimation {
            draggingItem = nil
            
        }
    }
}
