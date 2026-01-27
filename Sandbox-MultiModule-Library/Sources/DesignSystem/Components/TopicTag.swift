//
//  TopicTag.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

public import SwiftUI

// MARK: - TopicTag
/// トピックを表示するタグコンポーネント
public struct TopicTag: View {
    private let text: String
    private let color: Color

    public var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    public init(
        _ text: String,
        color: Color = .blue
    ) {
        self.text = text
        self.color = color
    }
}

// MARK: - Preview
#Preview("TopicTag - Single", traits: .sizeThatFitsLayout) {
    TopicTag("swift")
        .padding()
}

#Preview("TopicTag - Multiple Colors", traits: .sizeThatFitsLayout) {
    VStack(spacing: 12) {
        HStack {
            TopicTag("swift", color: .orange)
            TopicTag("ios", color: .blue)
            TopicTag("macos", color: .purple)
        }
        HStack {
            TopicTag("compiler", color: .green)
            TopicTag("llvm", color: .red)
        }
    }
    .padding()
}

#Preview("TopicTag - With FlowLayout", traits: .sizeThatFitsLayout) {
    FlowLayout(spacing: 8) {
        ForEach([
            "swift",
            "compiler",
            "llvm",
            "programming-language",
            "open-source",
            "apple"
        ], id: \.self) { topic in
            TopicTag(topic)
        }
    }
    .padding()
}
