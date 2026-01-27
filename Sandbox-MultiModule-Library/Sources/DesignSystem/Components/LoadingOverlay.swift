//
//  LoadingOverlay.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

public import SwiftUI

// MARK: - LoadingOverlay ViewModifier
/// ローディング中にProgressViewをオーバーレイ表示するViewModifier
public struct LoadingOverlay: ViewModifier {
    private let isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
    }
}

// MARK: - View Extension
public extension View {
    /// ローディング中にProgressViewをオーバーレイ表示する
    /// - Parameter isLoading: ローディング状態
    /// - Returns: オーバーレイが適用されたView
    func loadingOverlay(isLoading: Bool) -> some View {
        modifier(LoadingOverlay(isLoading: isLoading))
    }
}

// MARK: - Preview
#Preview("LoadingOverlay - Loading") {
    List {
        Text("Item 1")
        Text("Item 2")
        Text("Item 3")
    }
    .loadingOverlay(isLoading: true)
}

#Preview("LoadingOverlay - Not Loading") {
    List {
        Text("Item 1")
        Text("Item 2")
        Text("Item 3")
    }
    .loadingOverlay(isLoading: false)
}
