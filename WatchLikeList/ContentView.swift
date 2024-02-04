//
//  ContentView.swift
//  WatchLikeList
//
//  Created by 香饽饽zizizi on 2024/2/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(1...100, id: \.self) { idx in
                            RowView(scrollViewHeight: geo.size.height)
                        }
                    }
                    .padding(20)
                }
                .coordinateSpace(.named("scrollView"))
            }
            .navigationTitle("列表")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RowView: View {
    var scrollViewHeight: CGFloat = 0
    @State var scale: CGFloat = 1

    var body: some View {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .frame(height: 140)
            .foregroundStyle(.gray.opacity(0.3))
            .scaleEffect(scale, anchor: .center)
            .overlay {
                GeometryReader { geo in
                    let rect = geo.frame(in: .named("scrollView"))

                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            scale = calc(itemRect: value)
                        }
                }
            }
    }

    func calc(itemRect: CGRect) -> CGFloat {
        if (itemRect.minY < 0) {
            let s = (itemRect.minY + 300) / 300
            return s
        } else if (itemRect.maxY > scrollViewHeight) {
            let s = 300 / (itemRect.maxY - scrollViewHeight + 300)
            return s
        } else {
            return 1
        }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
