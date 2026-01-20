//
//  SearchRepositoryRepositoryImpl.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import Foundation
import InfraDescriptor
import Model
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - DependencyKey
extension SearchRepositoryRepository: DependencyKey {
    public static let liveValue = Self(
        search: { query in
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let response = try await client.searchRepos(query: .init(q: query))
                .ok
                .body
                .json
            return response.items.compactMap { item in
                guard let htmlUrl = URL(string: item.htmlUrl) else { return nil }
                return SearchResultItem(
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
    )
}
