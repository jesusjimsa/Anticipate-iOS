//
//  CountdownsManager.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 11/4/25.
//

import Foundation
import SwiftUI
import SwiftData

func getAllEvents(modelContext: ModelContext) -> [CountdownEvent] {
    let descriptor = FetchDescriptor<CountdownEvent>()
    
    do {
        let allEvents = try modelContext.fetch(descriptor)
        return allEvents
    }
    catch {
        print("Error fetching events: \(error)")
        return []
    }
}
