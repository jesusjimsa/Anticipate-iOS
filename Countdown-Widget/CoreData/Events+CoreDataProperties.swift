//
//  Events+CoreDataProperties.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 25/4/23.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: URL?
    @NSManaged public var date: Date?

}

extension Events : Identifiable {

}
