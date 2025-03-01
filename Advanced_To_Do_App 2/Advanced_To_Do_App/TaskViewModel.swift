//
//  TaskViewModel.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import Foundation
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    init() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func schedualTaskNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Your task '\(task.title)' is due soon!"
        content.sound = .default
        
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: task.dueDate) ?? task.dueDate
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification schedualing error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelTaskNotification(task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
    
    func addTask(title: String, dueDate: Date, category: TaskCategory, priority: TaskPriority) {
        let status = determineStatus(for: dueDate)
        let newTask = Task(title: title, dueDate: dueDate, status: status, priority: priority, category: category)
        tasks.append(newTask)
        schedualTaskNotification(for: newTask)
    }
    
    
    func updateTaskStatus() {
        for i in tasks.indices {
            tasks[i].status = determineStatus(for: tasks[i].dueDate)
        }
    }
    
    private func determineStatus(for dueDate: Date) -> TaskStatus {
        let now = Date()
        if dueDate < now {
            return .overdue
        }else if dueDate < now.addingTimeInterval(60 * 60 * 24) {
            return .nearDue
        }
        return .pending
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            if tasks[index].status == .completed {
                tasks[index].status = .pending
            } else {
                tasks[index].status = .completed
            }
            
            objectWillChange.send()
        }
    }
    
    func editTask(id: UUID, title: String, dueDate: Date, priority: TaskPriority, category: TaskCategory) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = title
            tasks[index].dueDate = dueDate
            tasks[index].priority = priority
            tasks[index].category = category
            tasks[index].status = determineStatus(for: dueDate)
        }
    }
}

