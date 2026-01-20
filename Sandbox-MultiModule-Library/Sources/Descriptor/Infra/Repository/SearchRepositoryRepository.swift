//
//  SearchRepositoryRepository.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
import Model

@DependencyClient
public struct SearchRepositoryRepository: Sendable {
    public var search: @Sendable (_ query: String) async throws -> [SearchResultItem]
}

// MARK: - TestDependencyKey
extension SearchRepositoryRepository: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var searchRepositoryRepository: SearchRepositoryRepository {
        get { self[SearchRepositoryRepository.self] }
        set { self[SearchRepositoryRepository.self] = newValue }
    }
}
