import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var showAddTask = false
    @State private var taskToEdit: Task? = nil
    @State private var sortOption = SortOption.priority
    @State private var showCalendar = false
    @State private var selectedDate: Date? = nil
    
    
    var body: some View {
        NavigationStack {
            if let user = authViewModel.user {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.pink.opacity(0.5)]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Welcome, \(user.username)")
                            .font(.title)
                            .padding(7)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                        
                        
                        Picker("Sort by", selection: $sortOption) {
                            Text("Priority").tag(SortOption.priority)
                            Text("Status").tag(SortOption.status)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        List {
                            if taskViewModel.tasks.isEmpty {
                                noTasksView
                            } else {
                                ForEach(sortedTasks()) { task in
                                    taskRow(for: task)
                                        .swipeActions(edge: .leading) {
                                            Button(action: {
                                                taskViewModel.toggleTaskCompletion(for: task.id)
                                            }) {
                                                Label(task.status == .completed ? "Undo" : "Complete", systemImage: task.status == .completed ? "arrow.uturn.left.circle.fill" : "checkmark.circle.fill")
                                            }
                                            .tint(task.status == .completed ? .gray : .green)
                                        }
                                }
                                .onDelete(perform: deleteTask)
                            }
                        }
                        
                        
                        .navigationTitle("Tickit")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    authViewModel.logout()
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                            }
                            ToolbarItem(placement: .principal) {
                                Text("Tickit")
                                    .font(.title)
                                    .padding(7)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pink.opacity(0.8))
                            }
        
                        }
                    }
                    .toolbar {
                        addButton
                        calendarButton
                }
                    .padding(.top)
                    .sheet(isPresented: $showAddTask) {
                        AddTaskView(taskViewModel: taskViewModel, taskToEdit: $taskToEdit)
                    }
                    .sheet(isPresented: $showCalendar) {
                        CalendarView(selectedDate: $selectedDate, taskViewModel: taskViewModel)
                    }
                }
                } else {
                    LoginView()
                }
            }
        }
    
    

    // MARK: - No Tasks View
    private var noTasksView: some View {
        VStack {
            Image(systemName: "note.text")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink.opacity(0.5))
           
            Text("No tasks created yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.pink.opacity(0.8))
           
            Text("Start by adding a new task!")
                .font(.subheadline)
                .foregroundColor(.pink.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Add Button
    private var addButton: some View {
        Button(action: {
            taskToEdit = nil
            showAddTask.toggle()
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .padding(7)
                .background(Color.pink.opacity(0.8), in: Circle())
                .shadow(radius: 5)
        }
    }

    // MARK: - Calendar Button
    private var calendarButton: some View {
        Button(action: {
            showCalendar.toggle()
        }) {
            Image(systemName: "calendar")
                .font(.title2)
                .foregroundColor(.white)
                .padding(7)
                .background(Color.pink.opacity(0.8), in: Circle())
                .shadow(radius: 5)
        }
    }

    // MARK: - Delete Task
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = taskViewModel.tasks[index]
            taskViewModel.deleteTask(byId: task.id)
        }
    }

    // MARK: - Task Row
    private func taskRow(for task: Task) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink.opacity(0.8))
               
                Text("Due: \(formattedDate(task.dueDate))")
                    .font(.subheadline)
                    .foregroundColor(.pink.opacity(0.5))
               
                Text("Category: \(task.category.rawValue)")
                    .font(.caption)
                    .foregroundColor(.pink.opacity(0.5))
               
                Text("Priority: \(task.priority.rawValue)")
                    .font(.caption)
                    .padding(8)
                    .background(priorityColor(for: task.priority).opacity(0.2))
                    .foregroundColor(priorityColor(for: task.priority))
                    .cornerRadius(6)
            }
            Text(task.status.rawValue)
                .foregroundColor(statusColor(for: task.status))
                .fontWeight(.bold)
                .padding(6)
                .background(statusColor(for: task.status).opacity(0.2))
                .cornerRadius(6)
           
            editButton(for: task)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(task.status == .completed ? Color.green.opacity(0.3) : Color.pink.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    // MARK: - Status Color
    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .overdue:
            return .red
        case .nearDue:
            return .orange
        case .pending:
            return .blue
        case .completed:
            return .green
        }
    }
   
    // MARK: - Sorting Tasks
    private func sortedTasks() -> [Task] {
        switch sortOption {
        case .priority:
            return taskViewModel.tasks.sorted { $0.priority.rawValue < $1.priority.rawValue }
        case .status:
            return taskViewModel.tasks.sorted { $0.status.rawValue < $1.status.rawValue }
        }
    }

    // MARK: - Priority Color
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }

    // MARK: - Edit Button
    private func editButton(for task: Task) -> some View {
        Button(action: {
            taskToEdit = task
            showAddTask.toggle()
        }) {
            Image(systemName: "pencil")
                .font(.title2)
                .foregroundColor(.pink)
                .padding(8)
                .background(Circle().fill(Color.white).shadow(radius: 3))
        }
    }

    // MARK: - Format Date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

