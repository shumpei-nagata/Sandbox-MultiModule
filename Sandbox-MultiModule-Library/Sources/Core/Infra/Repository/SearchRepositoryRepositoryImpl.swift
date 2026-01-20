//
//  SearchRepositoryRepositoryImpl.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import InfraDescriptor
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
            return try await client.searchRepos(query: .init(q: query))
                .ok
                .body
                .json
                .items
                .map(\.name)
        }
    )
}
