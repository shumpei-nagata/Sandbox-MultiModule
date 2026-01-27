//
//  SearchRepositoryViewModel.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

import Dependencies
import Domain
import Foundation
import InPort

@Observable
final class SearchRepositoryViewModel {
    var query: String = ""
    var repositories: [SearchResultItem] = []
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""

    @Dependency(\.searchRepositoryUseCase)
    @ObservationIgnored private var searchRepositoryUseCase

    func search() async {
        isLoading = true
        defer { isLoading = false }

        do {
            repositories = try await searchRepositoryUseCase.execute(query: query)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
