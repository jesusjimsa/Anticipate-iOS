//
//  CountdownsBundle.swift
//  Countdowns
//
//  Created by Jesús Jiménez Sánchez on 8/4/25.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

@main
struct CountdownsBundle: WidgetBundle {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CountdownEvent.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        let modelContainer = self.sharedModelContainer

        AppDependencyManager.shared.add(dependency: modelContainer) // Init modelContainer Dependency
    }
    
    var body: some Widget {
        Countdowns()
        CountdownsControl()
    }
}
