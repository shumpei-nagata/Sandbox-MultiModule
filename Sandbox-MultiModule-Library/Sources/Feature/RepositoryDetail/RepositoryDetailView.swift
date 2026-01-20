//
//  RepositoryDetailView.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DomainDescriptor
public import FeatureDescriptor
import Model
import SwiftUI

struct RepositoryDetailView: View {
    @State private var viewModel: RepositoryDetailViewModel

    init(item: SearchResultItem) {
        _viewModel = State(initialValue: RepositoryDetailViewModel(item: item))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = viewModel.detail {
                    headerSection(detail: detail)
                    Divider()
                    statsSection(detail: detail)
                    Divider()
                    infoSection(detail: detail)
                    if !detail.topics.isEmpty {
                        Divider()
                        topicsSection(topics: detail.topics)
                    }
                }
            }
            .padding()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.item.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    @ViewBuilder
    private func headerSection(detail: RepositoryDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: detail.owner.avatarUrl) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(detail.fullName)
                        .font(.headline)
                    Text(detail.owner.login)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if let description = detail.description {
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func statsSection(detail: RepositoryDetail) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            statItem(value: detail.stargazersCount, label: "Stars", icon: "star")
            statItem(value: detail.forksCount, label: "Forks", icon: "tuningfork")
            statItem(value: detail.openIssuesCount, label: "Issues", icon: "exclamationmark.circle")
            statItem(value: detail.watchersCount, label: "Watchers", icon: "eye")
            statItem(value: detail.size, label: "Size (KB)", icon: "externaldrive")
        }
    }

    @ViewBuilder
    private func statItem(value: Int, label: String, icon: String) -> some View {
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

    @ViewBuilder
    private func infoSection(detail: RepositoryDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let language = detail.language {
                infoRow(label: "Language", value: language)
            }
            infoRow(label: "Default Branch", value: detail.defaultBranch)
            infoRow(label: "Created", value: detail.createdAt.formatted(date: .abbreviated, time: .omitted))
            infoRow(label: "Updated", value: detail.updatedAt.formatted(date: .abbreviated, time: .omitted))
            if detail.archived {
                Label("Archived", systemImage: "archivebox")
                    .foregroundStyle(.orange)
            }
        }
    }

    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
    }

    @ViewBuilder
    private func topicsSection(topics: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Topics")
                .font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(topics, id: \.self) { topic in
                    Text(topic)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: currentY + lineHeight), positions)
    }
}

// MARK: - ViewModel
@Observable
final class RepositoryDetailViewModel {
    let item: SearchResultItem
    var detail: RepositoryDetail?
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""

    @ObservationIgnored
    @Dependency(\.repositoryDetailUseCase) private var repositoryDetailUseCase

    init(item: SearchResultItem) {
        self.item = item
    }

    func load() async {
        guard detail == nil else { return }

        isLoading = true
        defer { isLoading = false }

        guard let owner = item.owner?.login else {
            errorMessage = "Invalid repository name"
            showError = true
            return
        }

        do {
            detail = try await repositoryDetailUseCase.execute(
                owner: owner,
                repo: item.name
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - DependencyKey
extension RepositoryDetailViewBuilder: DependencyKey {
    public static let liveValue = Self(
        build: { item in
            .init(RepositoryDetailView(item: item))
        }
    )
}

// MARK: - Preview
#Preview {
    NavigationStack {
        withDependencies {
            $0.repositoryDetailUseCase.execute = { _, _ in
                .init(
                    id: 1,
                    name: "swift",
                    fullName: "apple/swift",
                    owner: .init(
                        id: 1,
                        login: "apple",
                        avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145")!
                    ),
                    description: "The Swift Programming Language",
                    htmlUrl: URL(string: "https://github.com/apple/swift")!,
                    cloneUrl: URL(string: "https://github.com/apple/swift.git")!,
                    sshUrl: "git@github.com:apple/swift.git",
                    language: "Swift",
                    stargazersCount: 65000,
                    watchersCount: 65000,
                    forksCount: 10000,
                    openIssuesCount: 500,
                    size: 800000,
                    defaultBranch: "main",
                    topics: ["swift", "compiler", "llvm", "programming-language"],
                    visibility: "public",
                    hasIssues: true,
                    hasProjects: false,
                    hasWiki: false,
                    hasPages: false,
                    hasDiscussions: true,
                    archived: false,
                    disabled: false,
                    isTemplate: false,
                    createdAt: .now.addingTimeInterval(-86400 * 365 * 10),
                    updatedAt: .now,
                    pushedAt: .now
                )
            }
        } operation: {
            RepositoryDetailView(
                item: .init(
                    id: 1,
                    name: "swift",
                    fullName: "apple/swift",
                    owner: .init(
                        id: 0,
                        login: "apple",
                        avatarUrl: .temporaryDirectory
                    ),
                    description: "The Swift Programming Language",
                    htmlUrl: URL(string: "https://github.com/apple/swift")!,
                    language: "Swift",
                    stargazersCount: 65000,
                    watchersCount: 65000,
                    forksCount: 10000,
                    openIssuesCount: 500,
                    defaultBranch: "main",
                    createdAt: .now,
                    updatedAt: .now
                )
            )
        }
    }
}
