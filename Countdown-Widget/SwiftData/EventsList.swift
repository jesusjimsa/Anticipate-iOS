//
//  Item.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import Foundation
import SwiftData

@Model
class EventsList {
    var id: String
    var title: String
    var date: Date
    var image: Data

    init(id: String, title: String, date: Date, image: Data) {
        self.id = id
        self.title = title
        self.date = date
        self.image = image
    }
}
