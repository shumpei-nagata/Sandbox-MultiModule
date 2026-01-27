//
//  RepositoryDetailView.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DesignSystem
import Domain
public import FeatureBuilder
import Prefire
import SwiftUI

// MARK: - RepositoryDetailView
struct RepositoryDetailView: View {
    @State private var viewModel: RepositoryDetailViewModel

    var body: some View {
        RepositoryDetailContentView(
            detail: viewModel.detail,
            isLoading: viewModel.isLoading
        )
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
}

// MARK: - RepositoryDetailContentView
struct RepositoryDetailContentView: View {
    let detail: RepositoryDetail?
    let isLoading: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail {
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
        .loadingOverlay(isLoading: isLoading)
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
            StatBadge.stars(detail.stargazersCount)
            StatBadge.forks(detail.forksCount)
            StatBadge.issues(detail.openIssuesCount)
            StatBadge.watchers(detail.watchersCount)
            StatBadge.size(detail.size)
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
                    TopicTag(topic)
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

extension RepositoryDetailFeaturePlaybookBuilder: DependencyKey {
    public static let liveValue = Self {
        .init(
            PlaybookView(
                isComponent: true,
                previewModels: PreviewModels.models
            )
        )
    }
}

// MARK: - Preview
#Preview("With Detail") {
    RepositoryDetailContentView(
        detail: RepositoryDetail(
            id: 1,
            name: "swift",
            fullName: "swiftlang/swift",
            owner: .init(
                id: 1,
                login: "swiftlang",
                avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/10639145")!
            ),
            description: "The Swift Programming Language",
            htmlUrl: .temporaryDirectory,
            cloneUrl: .temporaryDirectory,
            sshUrl: "",
            language: "Swift",
            stargazersCount: 65_000,
            watchersCount: 65_000,
            forksCount: 10_000,
            openIssuesCount: 500,
            size: 800_000,
            defaultBranch: "main",
            topics: [
                "swift",
                "compiler",
                "llvm",
                "programming-language"
            ],
            visibility: "public",
            hasIssues: true,
            hasProjects: false,
            hasWiki: false,
            hasPages: false,
            hasDiscussions: true,
            archived: false,
            disabled: false,
            isTemplate: false,
            createdAt: .distantPast,
            updatedAt: .init(timeIntervalSince1970: 1_767_193_200),
            pushedAt: .init(timeIntervalSince1970: 1_767_193_200)
        ),
        isLoading: false
    )
}

#Preview("Loading") {
    RepositoryDetailContentView(
        detail: nil,
        isLoading: true
    )
}
