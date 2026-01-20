//
//  SearchRepositoryPort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Domain

@DependencyClient
public struct SearchRepositoryPort: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    public var search: @concurrent @Sendable (_ query: String) async throws -> [SearchResultItem]
}

// MARK: - TestDependencyKey
extension SearchRepositoryPort: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var searchRepositoryPort: SearchRepositoryPort {
        get { self[SearchRepositoryPort.self] }
        set { self[SearchRepositoryPort.self] = newValue }
    }
}
