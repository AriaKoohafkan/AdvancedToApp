//
//  TaskM+CoreDataProperties.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-15.
//
//

import Foundation
import CoreData


extension TaskM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskM> {
        return NSFetchRequest<TaskM>(entityName: "TaskM")
    }

    @NSManaged public var category: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var user: UserM?

}

extension TaskM : Identifiable {

}
