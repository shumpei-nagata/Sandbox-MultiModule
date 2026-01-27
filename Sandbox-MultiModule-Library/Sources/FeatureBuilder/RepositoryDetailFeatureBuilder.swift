//
//  RepositoryDetailFeatureBuilder.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Domain
public import SwiftUI

@DependencyClient
public struct RepositoryDetailFeatureBuilder: Sendable {
    public var build: @Sendable @MainActor (_ item: SearchResultItem) -> AnyView = { _ in
        .init(EmptyView())
    }
}

// MARK: - TestDependencyKey
extension RepositoryDetailFeatureBuilder: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
public extension DependencyValues {
    var repositoryDetailFeatureBuilder: RepositoryDetailFeatureBuilder {
        get { self[RepositoryDetailFeatureBuilder.self] }
        set { self[RepositoryDetailFeatureBuilder.self] = newValue }
    }
}

@DependencyClient
public struct RepositoryDetailFeaturePlaybookBuilder: Sendable {
    public var build: @Sendable @MainActor () -> AnyView = {
        .init(EmptyView())
    }
}

extension RepositoryDetailFeaturePlaybookBuilder: TestDependencyKey {
    public static let testValue = Self()
}

public extension DependencyValues {
    var repositoryDetailFeaturePlaybookBuilder: RepositoryDetailFeaturePlaybookBuilder {
        get { self[RepositoryDetailFeaturePlaybookBuilder.self] }
        set { self[RepositoryDetailFeaturePlaybookBuilder.self] = newValue }
    }
}
