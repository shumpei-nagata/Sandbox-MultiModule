//
//  SearchRepositoryView.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import Domain
import DrivingPort
public import FeatureBuilder
import SwiftUI

struct SearchRepositoryView: View {
    @State private var viewModel = SearchRepositoryViewModel()
    @Dependency(\.repositoryDetailFeatureBuilder.build) private var repositoryDetailView

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.repositories) { repository in
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
                if viewModel.repositories.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView.search(text: viewModel.query)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Search Repositories")
            .navigationDestination(for: SearchResultItem.self) {
                AnyView(repositoryDetailView($0))
            }
            .searchable(text: $viewModel.query, prompt: "Search repositories")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

@Observable
final class SearchRepositoryViewModel {
    var query: String = ""
    var repositories: [SearchResultItem] = []
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""

    @ObservationIgnored
    @Dependency(\.searchRepositoryUseCase) private var searchRepositoryUseCase

    func search() async {
        isLoading = true
        defer { isLoading = false }

        do {
            repositories = try await searchRepositoryUseCase.execute(query: query)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - DependencyKey
extension SearchRepositoryFeatureBuilder: DependencyKey {
    public static let liveValue = Self(
        build: {
            .init(SearchRepositoryView())
        }
    )
}

// MARK: - Preview
#Preview {
    withDependencies {
        $0.searchRepositoryUseCase.execute = { query in
            if query.isEmpty {
                []
            } else {
                (1...10).map { index in
                    SearchResultItem(
                        id: index,
                        name: "\(query)-\(index)",
                        fullName: "owner/\(query)-\(index)",
                        owner: nil,
                        description: "Sample repository description for \(query)",
                        htmlUrl: URL(string: "https://github.com/owner/\(query)-\(index)")!,
                        language: "Swift",
                        stargazersCount: index * 100,
                        watchersCount: index * 10,
                        forksCount: index * 5,
                        openIssuesCount: index,
                        defaultBranch: "main",
                        createdAt: .now,
                        updatedAt: .now
                    )
                }
            }
        }
    } operation: {
        SearchRepositoryView()
    }
}
