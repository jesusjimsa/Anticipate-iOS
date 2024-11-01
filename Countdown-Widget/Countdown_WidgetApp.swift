//
//  Countdown_WidgetApp.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import SwiftUI
import SwiftData

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

@main
struct Countdown_WidgetApp: App {
    @StateObject private var themeManager = ThemeManager.shared

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

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(themeManager.appTheme.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
