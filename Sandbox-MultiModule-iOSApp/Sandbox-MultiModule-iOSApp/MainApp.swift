//
//  MainApp.swift
//  Sandbox-MultiModule-iOSApp
//
//  Created by Shumpei Nagata on 2026/01/19.
//

import Dependencies
import FeatureBuilder
import SwiftUI

@main
struct MainApp: App {
    @Dependency(\.searchRepositoryFeatureBuilder.build) private var searchRepositoryView

    var body: some Scene {
        WindowGroup {
            searchRepositoryView()
        }
    }
}
