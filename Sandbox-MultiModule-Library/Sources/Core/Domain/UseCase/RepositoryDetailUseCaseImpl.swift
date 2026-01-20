//
//  RepositoryDetailUseCaseImpl.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DomainDescriptor
import InfraDescriptor

// MARK: - DependencyKey
extension RepositoryDetailUseCase: DependencyKey {
    public static let liveValue = Self(
        execute: { owner, repo in
            @Dependency(\.repositoryDetailRepository) var repository
            return try await repository.get(owner: owner, repo: repo)
        }
    )
}
