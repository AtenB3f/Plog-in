//
//  FrameList.swift
//  Design
//
//  Created by AtenB on 12/11/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore
import UniformTypeIdentifiers

public struct FrameListState {
    public var mode: FrameListMode
    public var index: Int?
    public var isFolding: Bool

    public init(
        mode: FrameListMode = .none,
        index: Int? = nil,
        isFolding: Bool = true
    ) {
        self.mode = mode
        self.index = index
        self.isFolding = isFolding
    }
}

public enum FrameListMode {
    case none
    case select
    case edit
    case sort
}

public struct FrameList: View {
    var list: [FrameItemState]
    @Binding var state: FrameListState
    let onDelete: ((Int) -> Void)?
    let onMove: ((IndexSet, Int) -> Void)?
    
    @State private var hoverIndex: Int?
    private let spacing = 8.0
    private let size: Double
    
    public init(
        list: [PImage],
        titles: [String] = [],
        state: Binding<FrameListState>,
        size: Double = 76,
        onDelete: ((Int) -> Void)? = nil,
        onMove: ((IndexSet, Int) -> Void)? = nil
    ) {
        self.list = list.map { .init(image: $0)}
        for index in list.indices {
            self.list[index].title = titles.count > index ? titles[index] : ""
        }
        self._state = state
        self.size = size
        self.onDelete = onDelete
        self.onMove = onMove
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 0) {
                ForEach(list.indices, id: \.self) { index in
                    item(
                        state.mode,
                        index: index,
                        item: list[index]
                    )
                }
            }
            .padding(.horizontal, state.mode == .sort ? 0 : 16)
        }
        .fixedSize(horizontal: false, vertical: true)
        .scrollIndicators(.hidden)
        .onTapGesture {
            guard state.mode != .edit else { return }
            state.mode = .none
            state.index = nil
            hoverIndex = nil
        }
    }
    
    @ViewBuilder
    func item(_ mode: FrameListMode, index: Int, item: FrameItemState) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 0) {
                switch mode {
                case .sort:
                    Rectangle()
                        .foreground(.Base.dark)
                        .frame(
                            width: (hoverIndex == index) ? size : (index == 0 ? 16 : spacing),
                            height: size
                        )
                        .dropDestination(for: FrameItemState.self) { items, _ in
                            return onDropHander(items: items)
                        } isTargeted: { isTarget in
                            guard isTarget else { return }
                            onDragHandler(index: index)
                        }
                    
                    FrameItemView(
                        image: item.image,
                        index: index,
                        mode: .sort,
                        size: size,
                        onDelete: { onDelete?(index) }
                    )
                    .draggable(item)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                            .foreground(state.index == index ? .Text.light : .clear)
                    }
                    .dropDestination(for: FrameItemState.self) { items, _ in
                        return onDropHander(items: items)
                    } isTargeted: { isTarget in
                        guard isTarget else { return }
                        onDragHandler(index: list.count - 1 == index ? index+1 : index)
                    }
                    
                    if list.count - 1 == index {
                        Rectangle()
                            .foreground(.Base.dark)
                            .frame(
                                width: hoverIndex == list.count ? size : 16,
                                height: size
                            )
                            .dropDestination(for: FrameItemState.self) { items, _ in
                                return onDropHander(items: items)
                            } isTargeted: { isTarget in
                                guard isTarget else { return }
                                onDragHandler(index: index+1)
                            }
                    }
                    
                default:
                    FrameItemView(
                        image: item.image,
                        index: index,
                        mode: state.mode == .edit ? .edit : (state.index == index ? .select : .none),
                        size: size,
                        onDelete: { onDelete?(index) }
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                            .foreground(state.index == index ? .Text.light : .clear)
                    }
                    .onTapGesture {
                        state.mode = state.mode == .edit ? .edit : .select
                        state.index = index
                        hoverIndex = nil
                    }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        state.mode = .sort
                        state.index = nil
                    }
                    
                    Spacer()
                        .frame(width: spacing, height: size)
                }
            }
            
            if !item.title.isEmpty {
                Text(item.title)
                    .font(.body1)
                    .foreground(.Text.light)
                    .frame(width: size, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
    
    @MainActor
    func onDragHandler(index: Int) {
        withAnimation {
            hoverIndex = index
        }
    }
    
    func onDropHander(items: [FrameItemState]) -> Bool {
        guard let item = items.first,
              let from = list.firstIndex(where: { $0.id == item.id }) else {
            hoverIndex = nil
            return false
        }
        guard var to = hoverIndex else {
            hoverIndex = nil
            return false
        }
        if from > to {
            if to == list.count {
                to = list.count - 1
            }
        } else if to == from {
            hoverIndex = nil
            return false
        }
        onMove?(.init(integer: from), to)
        hoverIndex = nil
        return true
    }
}

#Preview {
    @Previewable @State var list: [PImage] = [
        PImage(systemName: "star") ?? PImage(),
        PImage(systemName: "star.fill") ?? PImage(),
        PImage(systemName: "moon") ?? PImage(),
        PImage(systemName: "moon.fill") ?? PImage()
    ]
    @Previewable @State var state: FrameListState = .init()

    FrameList(
        list: list,
        titles: ["starstarstar", "star", "moon", "moon"],
        state: $state,
        size: 76,
        onDelete: {_ in
        }, onMove: {from, to in
            list.move(fromOffsets: from, toOffset: to)
        })
}
