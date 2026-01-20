//
//  SearchRepositoryFeatureBuilder.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import SwiftUI

@DependencyClient
public struct SearchRepositoryFeatureBuilder: Sendable {
    public var build: @Sendable @MainActor () -> AnyView = {
        .init(EmptyView())
    }
}

// MARK: - TestDependencyKey
extension SearchRepositoryFeatureBuilder: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var searchRepositoryFeatureBuilder: SearchRepositoryFeatureBuilder {
        get { self[SearchRepositoryFeatureBuilder.self] }
        set { self[SearchRepositoryFeatureBuilder.self] = newValue }
    }
}
