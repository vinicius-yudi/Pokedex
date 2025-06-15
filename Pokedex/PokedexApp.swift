//
//  PokedexApp.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import SwiftUI
import SwiftData

@main
struct PokedexApp: App {
    @StateObject var vm = PokedexListViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Usuario.self, Favorito.self])
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
                .environmentObject(vm)

        }
        .modelContainer(sharedModelContainer)
    }
}
