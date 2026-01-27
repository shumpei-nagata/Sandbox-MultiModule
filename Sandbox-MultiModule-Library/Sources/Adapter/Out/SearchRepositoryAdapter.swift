//
//  SearchRepositoryRepositoryImpl.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import Domain
import Foundation
import GitHubAPI
package import OutPort

// MARK: - DependencyKey
extension SearchRepositoryPort: DependencyKey {
    package static let liveValue = Self { query in
        @Dependency(\.gitHubAPI)
        var gitHubAPI

        let response = try await gitHubAPI.searchRepos(query: .init(q: query))
            .ok
            .body
            .json

        return response.items.compactMap { item in
            guard let htmlUrl = URL(string: item.htmlUrl) else {
                return nil
            }
            return .init(
                id: item.id,
                name: item.name,
                fullName: item.fullName,
                owner: item.owner.flatMap { owner in
                    URL(string: owner.avatarUrl).map {
                        .init(
                            id: Int(owner.id),
                            login: owner.login,
                            avatarUrl: $0
                        )
                    }
                },
                description: item.description,
                htmlUrl: htmlUrl,
                language: item.language,
                stargazersCount: item.stargazersCount,
                watchersCount: item.watchersCount,
                forksCount: item.forksCount,
                openIssuesCount: item.openIssuesCount,
                defaultBranch: item.defaultBranch,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt
            )
        }
    }
}
