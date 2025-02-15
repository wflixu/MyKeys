//
//  MyKeysApp.swift
//  MyKeys
//
//  Created by 李旭 on 2024/12/6.
//

import SwiftUI
import SwiftData

@main
struct MyKeysApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PasswordItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
