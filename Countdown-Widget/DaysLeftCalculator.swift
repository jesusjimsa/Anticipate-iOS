//
//  DaysLeft.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/7/23.
//

import Foundation

func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
}

func daysLeft(date: Date) -> Int {
    return daysBetween(start: Date(), end: date)
}

