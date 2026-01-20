//
//  RepositoryDetailViewBuilder.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
import Model
import SwiftUI

@DependencyClient
public struct RepositoryDetailViewBuilder: Sendable {
    public var build: @Sendable @MainActor (_ item: SearchResultItem) -> AnyView = { _ in
        .init(EmptyView())
    }
}

// MARK: - TestDependencyKey
extension RepositoryDetailViewBuilder: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var repositoryDetailViewBuilder: RepositoryDetailViewBuilder {
        get { self[RepositoryDetailViewBuilder.self] }
        set { self[RepositoryDetailViewBuilder.self] = newValue }
    }
}
