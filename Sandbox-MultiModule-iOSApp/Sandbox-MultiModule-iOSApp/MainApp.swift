//
//  MainApp.swift
//  Sandbox-MultiModule-iOSApp
//
//  Created by Shumpei Nagata on 2026/01/19.
//

import Dependencies
import DesignSystem
import FeatureBuilder
import SwiftUI

@main
struct MainApp: App {
    @Dependency(\.searchRepositoryFeatureBuilder.build)
    private var searchRepositoryView

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab(
                    "Search",
                    systemImage: "magnifyingglass",
                    role: .search
                ) {
                    searchRepositoryView()
                }

                #if DEBUG
                Tab(
                    "Developer",
                    systemImage: "wrench.and.screwdriver"
                ) {
                    NavigationStack {
                        List {
                            NavigationLink("DesignSystem") {
                                DesignSystemPlaybook()
                            }
                            NavigationLink("RepositoryDetail") {
                                @Dependency(\.repositoryDetailFeaturePlaybookBuilder.build)
                                var repositoryDetailPlaybook

                                repositoryDetailPlaybook()
                            }
                            NavigationLink("SearchRepository") {
                                @Dependency(\.searchRepositoryFeaturePlaybookBuilder.build)
                                var searchRepositoryPlaybook

                                searchRepositoryPlaybook()
                            }
                        }
                        .navigationTitle("Developer")
                    }
                }
                #endif
            }
        }
    }
}
