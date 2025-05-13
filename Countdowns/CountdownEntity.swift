//
//  CountdownEntity.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/4/25.
//

import Foundation
import SwiftData
import SwiftUI
import AppIntents

struct CountdownEntity: AppEntity, Identifiable {
    var id: UUID
    var title: String
    var date: Date
    var image: Data
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
    
    static var defaultQuery = CountdownQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Countdown"
    
    init(id: UUID, title: String, date: Date, image: Data) {
        self.id = id
        self.title = title
        self.date = date
        self.image = image
    }
    
    init(id: UUID, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
        self.image = Data()
    }
    
    init(countdown: CountdownEvent) {
        self.id = countdown.id
        self.title = countdown.title
        self.date = countdown.date
        self.image = countdown.image
    }
}

struct CountdownQuery: EntityQuery {
    typealias Entity = CountdownEntity
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Countdown Event")

    static var defaultQuery = CountdownQuery()

    @Dependency // Added Dependency
    private var modelContainer: ModelContainer

    @MainActor  // Added Main Actor
    func entities(for identifiers: [UUID]) async throws -> [CountdownEntity] {
        let countdownEvents = getAllEvents(modelContext: modelContainer.mainContext)
        
        return countdownEvents.map { event in
            return CountdownEntity(id: event.id, title: event.title, date: event.date, image: event.image)
        }
    }

    @MainActor  // Added Main Actor
    func suggestedEntities() async throws -> [CountdownEntity] {
        // Return some suggested entities or an empty array
        let countdownEvents = getAllEvents(modelContext: modelContainer.mainContext)
        
        let suggestedCountdowns = countdownEvents.map { event in
            CountdownEntity(id: event.id, title: event.title, date: event.date, image: event.image)
        }
        
        return Array(suggestedCountdowns.prefix(20))
//        return countdownEvents.map { event in
//            return CountdownEntity(id: event.id, title: event.title, date: event.date, image: event.image)
//        }
    }
    
}
