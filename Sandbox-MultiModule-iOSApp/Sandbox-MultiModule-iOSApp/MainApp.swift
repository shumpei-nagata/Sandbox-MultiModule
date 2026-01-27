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
    @Dependency(\.repositoryDetailFeaturePlaybookBuilder.build)
    private var repositoryDetailPlaybook
    @Dependency(\.searchRepositoryFeaturePlaybookBuilder.build)
    private var searchRepositoryPlaybook

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Search", systemImage: "magnifyingglass") {
                    searchRepositoryView()
                }

                #if DEBUG
                Tab("Developer", systemImage: "wrench.and.screwdriver") {
                    NavigationStack {
                        List {
                            NavigationLink("DesignSystem") {
                                DesignSystemPlaybook()
                            }
                            NavigationLink("RepositoryDetail") {
                                repositoryDetailPlaybook()
                            }
                            NavigationLink("SearchRepository") {
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
