//
//  UserCountdowns+CoreDataProperties.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 2/5/23.
//
//

import Foundation
import CoreData


extension UserCountdowns {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCountdowns> {
        return NSFetchRequest<UserCountdowns>(entityName: "UserCountdowns")
    }

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?

}

extension UserCountdowns : Identifiable {

}
