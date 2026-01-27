//
//  RepositoryDetailView.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import Domain
public import FeatureBuilder
import InPort
import SwiftUI

struct RepositoryDetailView: View {
    @State private var viewModel: RepositoryDetailViewModel

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

    init(item: SearchResultItem) {
        _viewModel = State(initialValue: RepositoryDetailViewModel(item: item))
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

// MARK: - DependencyKey
extension RepositoryDetailFeatureBuilder: DependencyKey {
    public static let liveValue = Self { item in
        .init(RepositoryDetailView(item: item))
    }
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
                    stargazersCount: 65_000,
                    watchersCount: 65_000,
                    forksCount: 10_000,
                    openIssuesCount: 500,
                    size: 800_000,
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
                    createdAt: .now.addingTimeInterval(-86_400 * 365 * 10),
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
                    stargazersCount: 65_000,
                    watchersCount: 65_000,
                    forksCount: 10_000,
                    openIssuesCount: 500,
                    defaultBranch: "main",
                    createdAt: .now,
                    updatedAt: .now
                )
            )
        }
    }
}
