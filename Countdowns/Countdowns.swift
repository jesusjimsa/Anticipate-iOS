//
//  Countdowns.swift
//  Countdowns
//
//  Created by Jesús Jiménez Sánchez on 8/4/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct CountdownsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
//        ZStack {
//            createImage(entry.configuration.countdown!.image)
            VStack {
                Text(entry.configuration.countdown?.title ?? "Default")
                    .foregroundStyle(.white)
                    .shadow(
                            color: Color.primary.opacity(0.3), /// shadow color
                            radius: 3, /// shadow radius
                            x: 0, /// x offset
                            y: 2 /// y offset
                        )
                Text("\(daysLeft(date: entry.configuration.countdown?.date ?? Date())) days left")
                    .foregroundStyle(.white)
                    .shadow(
                            color: Color.primary.opacity(0.3), /// shadow color
                            radius: 3, /// shadow radius
                            x: 0, /// x offset
                            y: 2 /// y offset
                        )
            }
//        }
    }
}

struct Countdowns: Widget {
    let kind: String = "Countdowns"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CountdownsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.countdown = CountdownEntity(id: UUID(), title: "Test", date: Date())
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.countdown = CountdownEntity(id: UUID(), title: "Test2", date: Date())
        return intent
    }
}

#Preview(as: .systemSmall) {
    Countdowns()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
