//
//  SearchRepositoryViewBuilder.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
import SwiftUI

@DependencyClient
public struct SearchRepositoryViewBuilder: Sendable {
    public var build: @Sendable @MainActor () -> any View = {
        EmptyView()
    }
}

// MARK: - TestDependencyKey
extension SearchRepositoryViewBuilder: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var searchRepositoryViewBuilder: SearchRepositoryViewBuilder {
        get { self[SearchRepositoryViewBuilder.self] }
        set { self[SearchRepositoryViewBuilder.self] = newValue }
    }
}
