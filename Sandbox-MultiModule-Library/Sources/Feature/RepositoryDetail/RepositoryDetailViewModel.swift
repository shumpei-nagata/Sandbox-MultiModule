//
//  RepositoryDetailViewModel.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

import Dependencies
import Domain
import Foundation
import InPort
import Observation

// MARK: - ViewModel
@Observable
final class RepositoryDetailViewModel {
    let item: SearchResultItem
    var detail: RepositoryDetail?
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""

    @Dependency(\.repositoryDetailUseCase)
    @ObservationIgnored private var repositoryDetailUseCase

    init(item: SearchResultItem) {
        self.item = item
    }

    func load() async {
        guard detail == nil else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        guard let owner = item.owner?.login else {
            errorMessage = "Invalid repository name"
            showError = true
            return
        }

        do {
            detail = try await repositoryDetailUseCase.execute(
                owner: owner,
                repo: item.name
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
