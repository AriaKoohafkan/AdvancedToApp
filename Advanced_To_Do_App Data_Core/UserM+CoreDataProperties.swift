//
//  UserM+CoreDataProperties.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-15.
//
//

import Foundation
import CoreData


extension UserM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserM> {
        return NSFetchRequest<UserM>(entityName: "UserM")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var password: String
    @NSManaged public var username: String
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension UserM {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskM)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskM)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension UserM : Identifiable {

}
