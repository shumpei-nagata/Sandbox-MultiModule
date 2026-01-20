//
//  SearchRepositoryUseCaseImpl.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
public import DomainDescriptor
import InfraDescriptor

// MARK: - DependencyKey
extension SearchRepositoryUseCase: DependencyKey {
    public static let liveValue = Self(
        execute: { query in
            @Dependency(\.searchRepositoryRepository) var repository
            return try await repository.search(query: query)
        }
    )
}
