//
//  DaysLeft.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/7/23.
//

import Foundation
import SwiftUI

func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
}

func daysLeft(date: Date) -> Int {
    return daysBetween(start: Date(), end: date)
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
