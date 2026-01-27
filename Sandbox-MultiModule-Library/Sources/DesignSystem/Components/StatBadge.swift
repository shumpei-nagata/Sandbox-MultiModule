//
//  StatBadge.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

public import SwiftUI

// MARK: - StatBadge
/// 統計情報を表示するバッジコンポーネント
public struct StatBadge: View {
    private let value: Int
    private let label: String
    private let icon: String

    public var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    public init(
        value: Int,
        label: String,
        icon: String
    ) {
        self.value = value
        self.label = label
        self.icon = icon
    }
}

// MARK: - Convenience Initializers
public extension StatBadge {
    /// スターカウント用のバッジ
    static func stars(_ count: Int) -> StatBadge {
        StatBadge(value: count, label: "Stars", icon: "star")
    }

    /// フォークカウント用のバッジ
    static func forks(_ count: Int) -> StatBadge {
        StatBadge(value: count, label: "Forks", icon: "tuningfork")
    }

    /// Issueカウント用のバッジ
    static func issues(_ count: Int) -> StatBadge {
        StatBadge(value: count, label: "Issues", icon: "exclamationmark.circle")
    }

    /// ウォッチャーカウント用のバッジ
    static func watchers(_ count: Int) -> StatBadge {
        StatBadge(value: count, label: "Watchers", icon: "eye")
    }

    /// サイズ表示用のバッジ
    static func size(_ sizeKB: Int) -> StatBadge {
        StatBadge(value: sizeKB, label: "Size (KB)", icon: "externaldrive")
    }
}

// MARK: - Preview
#Preview("StatBadge", traits: .sizeThatFitsLayout) {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 16) {
        StatBadge.stars(65_000)
        StatBadge.forks(10_000)
        StatBadge.issues(500)
        StatBadge.watchers(2_000)
        StatBadge.size(800_000)
        StatBadge(value: 42, label: "Custom", icon: "sparkles")
    }
    .padding()
}

#Preview("StatBadge - Single", traits: .sizeThatFitsLayout) {
    StatBadge.stars(1_234)
        .padding()
}
