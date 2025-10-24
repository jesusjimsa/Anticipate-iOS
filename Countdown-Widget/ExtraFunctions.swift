//
//  DaysLeft.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/7/23.
//

import Foundation
import SwiftUI

func daysLeft(date: Date) -> Int {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let startOfTargetDay = calendar.startOfDay(for: date)

    // Calculate the difference in days
    let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTargetDay)

    return components.day ?? 0
}

func createImage(_ value: Data) -> Image {
#if canImport(UIKit)
    let event_image: UIImage = UIImage(data: value) ?? UIImage()
    return Image(uiImage: event_image)
#elseif canImport(AppKit)
    let event_image: NSImage = NSImage(data: value) ?? NSImage()
    return Image(nsImage: event_image)
#else
    return Image(systemImage: "some_default")
#endif
}

func removeNotification(event_id: String) {
    let center = UNUserNotificationCenter.current()
    
    center.removePendingNotificationRequests(withIdentifiers: [event_id])
}

