//
//  TaskViewModel.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import Foundation
import UserNotifications
import CoreData

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private let context: NSManagedObjectContext
    static let shared = TaskViewModel(context: PersistenceController.shared.container.viewContext)
    
    private var user: UserM?
    
    init(context: NSManagedObjectContext, user: UserM? = nil) {
        self.context = context
        
        if let user = user {
            self.user = user
        } else {
            restoreLastUser()
        }
        requestNotificationPermission()
        fetchTasks()
    }
    
    func setUser(_ user: UserM) {
        self.user = user
        fetchTasks()
    }
    
    func updateUser(newUser: UserM) {
        self.user = newUser
        UserDefaults.standard.set(newUser.id?.uuidString, forKey: "lastLoggedInUserId")
        fetchTasks()
    }
    
    func restoreLastUser() {
        if let userIdString = UserDefaults.standard.string(forKey: "lastLoggedInUserID"),
           let userId = UUID(uuidString: userIdString) {

            let request: NSFetchRequest<UserM> = UserM.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", userId as CVarArg)

            do {
                let users = try context.fetch(request)
                if let lastUser = users.first {
                    DispatchQueue.main.async {
                        self.user = lastUser
                        self.fetchTasks()
                    }
                }
            } catch {
                print("Error restoring user: \(error.localizedDescription)")
            }
        }
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
        
        guard let currentUser = user else {
            print("No logged-in user found")
            return
        }
        
        let status = determineStatus(for: dueDate)
        let newTask = Task(title: title, dueDate: dueDate, status: status, category: category, priority: priority)
        tasks.append(newTask)
        
        let taskM = TaskM(context: context)
        taskM.id = newTask.id
        taskM.title = newTask.title
        taskM.dueDate = newTask.dueDate
        taskM.status = newTask.status.rawValue
        taskM.category = newTask.category.rawValue
        taskM.priority = newTask.priority.rawValue
        taskM.user = currentUser
        saveContext()
        schedualTaskNotification(for: newTask)
    }
    
    
    func updateTaskStatus() {
        for i in tasks.indices {
            tasks[i].status = determineStatus(for: tasks[i].dueDate)
        }
    }
    
    func fetchTasks() {
        guard let user = user, let userId = user.id else {
            tasks = []
            return
        }
        
        let request: NSFetchRequest<TaskM> = TaskM.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@", userId.uuidString)
        
        do {
            let taskMs = try context.fetch(request)
            tasks = taskMs.map { taskMToTask($0) }
        }catch {
            print("Error fetching tasks")
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
    
    func deleteTask(byId id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            let taskToDelete = tasks[index]
            tasks.remove(at: index)
            
            let fetchRequest: NSFetchRequest<TaskM> = TaskM.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let taskMs = try context.fetch(fetchRequest)
                for taskM in taskMs {
                    context.delete(taskM)
                }
                saveContext()
            }catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleTaskCompletion(for taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].status = tasks[index].status == .completed ? .pending : .completed
        }
    }
    
    func editTask(id: UUID, title: String, dueDate: Date, category: TaskCategory, priority: TaskPriority) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = title
            tasks[index].dueDate = dueDate
            tasks[index].category = category
            tasks[index].status = determineStatus(for: dueDate)
            tasks[index].priority = priority
            
            let request: NSFetchRequest<TaskM> = TaskM.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let taskMs = try context.fetch(request)
                if let taskM = taskMs.first {
                    taskM.title = title
                    taskM.dueDate = dueDate
                    taskM.category = category.rawValue
                    taskM.status = determineStatus(for: dueDate).rawValue
                    taskM.priority = priority.rawValue
                    saveContext()
                }
            }catch {
                print("Error editing task")
            }
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        }catch {
            print("Error saving context")
        }
    }
    
    
    private func taskToTaskM(_ task: Task, context: NSManagedObjectContext) -> TaskM {
        let taskM = TaskM(context: context)
        taskM.id = task.id
        taskM.title = task.title
        taskM.dueDate = task.dueDate
        taskM.status = task.status.rawValue
        taskM.category = task.category.rawValue
        taskM.priority = task.priority.rawValue
        return taskM
    }
    
    private func taskMToTask(_ taskM: TaskM) -> Task {
        return Task(
            id: taskM.id!,
            title: taskM.title ?? "Undefined",
            dueDate: taskM.dueDate ?? Date(),
            status: TaskStatus(rawValue: taskM.status ?? "pending") ?? .pending,
            category: TaskCategory(rawValue: taskM.category ?? "other") ?? .other,
            priority: TaskPriority(rawValue: taskM.priority ?? "low") ?? .low
        )
    }
}

