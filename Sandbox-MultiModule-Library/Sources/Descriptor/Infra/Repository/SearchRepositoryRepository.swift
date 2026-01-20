//
//  SearchRepositoryRepository.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Model

@DependencyClient
public struct SearchRepositoryRepository: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    public var search: @concurrent @Sendable (_ query: String) async throws -> [SearchResultItem]
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
