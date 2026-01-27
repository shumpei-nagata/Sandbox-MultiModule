//
//  SearchRepositoryView.swift
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

// MARK: - SearchRepositoryView
struct SearchRepositoryView: View {
    @State private var viewModel = SearchRepositoryViewModel()
    @Dependency(\.repositoryDetailFeatureBuilder.build)
    private var repositoryDetailView

    var body: some View {
        NavigationStack {
            SearchRepositoryContentView(
                repositories: viewModel.repositories,
                isLoading: viewModel.isLoading,
                query: viewModel.query
            )
            .navigationTitle("Search Repositories")
            .navigationDestination(for: SearchResultItem.self) {
                repositoryDetailView($0)
            }
            .searchable(text: $viewModel.query, prompt: "Search repositories")
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// MARK: - SearchRepositoryContentView
struct SearchRepositoryContentView: View {
    let repositories: [SearchResultItem]
    let isLoading: Bool
    let query: String

    var body: some View {
        List {
            ForEach(repositories) { repository in
                NavigationLink(value: repository) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(repository.fullName)
                            .font(.headline)
                        if let description = repository.description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        HStack(spacing: 12) {
                            Label("\(repository.stargazersCount)", systemImage: "star")
                            if let language = repository.language {
                                Text(language)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .overlay {
            if repositories.isEmpty, !isLoading {
                ContentUnavailableView.search(text: query)
            }
        }
        .loadingOverlay(isLoading: isLoading)
    }
}

// MARK: - DependencyKey
extension SearchRepositoryFeatureBuilder: DependencyKey {
    public static let liveValue = Self {
        .init(SearchRepositoryView())
    }
}

extension SearchRepositoryFeaturePlaybookBuilder: DependencyKey {
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
#Preview("With Results") {
    SearchRepositoryContentView(
        repositories: (1...5).map { index in
            SearchResultItem(
                id: index,
                name: "swift-\(index)",
                fullName: "apple/swift-\(index)",
                owner: nil,
                description: "Sample repository description for swift",
                htmlUrl: URL(string: "https://github.com/apple/swift-\(index)")!,
                language: "Swift",
                stargazersCount: index * 100,
                watchersCount: index * 10,
                forksCount: index * 5,
                openIssuesCount: index,
                defaultBranch: "main",
                createdAt: .now,
                updatedAt: .now
            )
        },
        isLoading: false,
        query: "swift"
    )
}

#Preview("Loading") {
    SearchRepositoryContentView(
        repositories: [],
        isLoading: true,
        query: "swift"
    )
}

#Preview("Empty") {
    SearchRepositoryContentView(
        repositories: [],
        isLoading: false,
        query: "nonexistent"
    )
}
