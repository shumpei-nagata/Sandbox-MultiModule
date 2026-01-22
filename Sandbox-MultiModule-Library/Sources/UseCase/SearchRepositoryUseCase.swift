//
//  SearchRepositoryUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
package import InPort
import OutPort

// MARK: - DependencyKey
extension SearchRepositoryUseCase: DependencyKey {
    package static let liveValue = Self(
        execute: { query in
            @Dependency(\.searchRepositoryPort) var port
            return try await port.search(query: query)
        }
    )
}
