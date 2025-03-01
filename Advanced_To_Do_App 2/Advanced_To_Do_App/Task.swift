//
//  Task.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import Foundation

enum TaskCategory: String, CaseIterable {
    case work = "Work"
    case personal = "Personal"
    case urgent = "Urgent"
    case other = "Other"
}

enum TaskStatus: String, CaseIterable {
    case pending = "Pending"
    case completed = "Completed"
    case overdue = "Overdue"
    case nearDue = "Near Due"
}

enum TaskPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date
    var status: TaskStatus
    var priority: TaskPriority
    var category: TaskCategory
}
