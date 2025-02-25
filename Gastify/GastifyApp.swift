//
//  GastifyApp.swift
//  Gastify
//
//  Created by Santiago Moreno on 5/01/25.
//

import SwiftUI

@main
struct GastifyApp: App {
    private let databaseService: DatabaseServiceProtocol = MockDatabaseService()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(databaseService))
        }
    }
}
