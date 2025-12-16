//
//  Countdowns.swift
//  Countdowns
//
//  Created by Jesús Jiménez Sánchez on 8/4/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func getForestConfiguration() -> ConfigurationAppIntent {
            let ten_days = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
            let forestData = UIImage(named: "forest")?.jpegData(compressionQuality: 0.5) ?? Data()
            
            let entity = CountdownEntity(
                id: UUID(),
                title: "Example",
                date: ten_days,
                image: forestData
            )
            
            return ConfigurationAppIntent(countdown: entity)
        }

        func placeholder(in context: Context) -> SimpleEntry {
            return SimpleEntry(date: Date(), configuration: getForestConfiguration())
        }

        func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
            return SimpleEntry(date: Date(), configuration: getForestConfiguration())
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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)

struct CountdownsEntryView : View {
    var entry: Provider.Entry
    let ten_days = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
    
    func daysLeftText(days_left: Int) -> String {
        var days_left_text: String = "\(days_left) days left"

        if days_left == 1 {
            days_left_text = "\(days_left) day left"
        }
        else if days_left == 0 {
            days_left_text = "Today!"
        }
        else if days_left < 0 {
            days_left_text = "\(abs(days_left)) days ago"
        }
        
        return days_left_text
    }

    var body: some View {
        ZStack {
            // Background image
            if let widgetImg = entry.configuration.countdown?.image,
               let uiImg = UIImage(data: widgetImg) {
                Image(uiImage: uiImg)
                    .resizable()
                    .scaledToFill()
            }
            else if let forestImg = UIImage(named: "forest") {
                Image(uiImage: forestImg)
                    .resizable()
                    .scaledToFill()
            }
            else {
                // Fallback gradient if no image
                LinearGradient(
                    colors: [Color.purple, Color.blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            if entry.configuration.countdown?.title == nil {
                Text("Long press and edit the widget to select countdown")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.01)
                    .lineLimit(3)
                    .shadow(
                            color: Color.primary.opacity(0.5), /// shadow color
                            radius: 3, /// shadow radius
                            x: 0, /// x offset
                            y: 2 /// y offset
                        )
            }
            else {
                VStack(spacing: 30) {
                    Text(entry.configuration.countdown?.title ?? "Example")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .shadow(
                                color: Color.primary.opacity(0.5), /// shadow color
                                radius: 3, /// shadow radius
                                x: 0, /// x offset
                                y: 2 /// y offset
                            )
                    
                    Text(daysLeftText(days_left: daysLeft(date: entry.configuration.countdown?.date ?? ten_days)))
                        .foregroundStyle(.white)
                        .font(.title)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .shadow(
                                color: Color.primary.opacity(0.5), /// shadow color
                                radius: 3, /// shadow radius
                                x: 0, /// x offset
                                y: 2 /// y offset
                            )
                }
                .padding()
            }
            
        }
    }
}

struct Countdowns: Widget {
    let kind: String = "Countdowns"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CountdownsEntryView(entry: entry)
                .containerBackground(.fill, for: .widget)
        }
        .contentMarginsDisabled()
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
