//
//  EventsList.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class CountdownEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    @Attribute(.externalStorage) var image: Data
    var notes: String = ""

    init(id: UUID, title: String, date: Date, image: Data, notes: String = "") {
        self.id = id
        self.title = title
        self.date = date
        self.image = image
        self.notes = notes
    }
}
