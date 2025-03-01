//
//  ContentView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//
import SwiftUI

struct ContentView: View {
   
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var showAddTask = false
    @State private var taskToEdit: Task? = nil
    @State private var searchText = ""
    @State private var isEditTaskPresented = false
   
    var body: some View {
        NavigationView {
            ZStack {
            
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
               
                VStack {
                 
                    HStack {
                        Text("To-Do List")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                       
                        Spacer()
                       
                       
                        TextField("Search by category...", text: $searchText)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                   
                
                    List {
                        ForEach(filteredTasks) { task in
                            taskRow(for: task)
                                .listRowBackground(Color.clear)
                        }
                       
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .foregroundColor(.white)
                   
                }
                .padding(.top)
            }
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showAddTask) {
                AddTaskView(taskViewModel: taskViewModel, taskToEdit: $taskToEdit)
            }
        }
    }
   
   
    private var filteredTasks: [Task] {
        if searchText.isEmpty {
            return taskViewModel.tasks
        } else {
            return taskViewModel.tasks.filter { $0.category.rawValue.localizedCaseInsensitiveContains(searchText) }
        }
    }
   
 
    private var addButton: some View {
        Button(action: {
            taskToEdit = nil
            showAddTask.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
   
 
    private func taskRow(for task: Task) -> some View {
        HStack {
         
            Image(systemName: task.status == .completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(task.status == .completed ? .green : .white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        taskViewModel.toggleTaskCompletion(task: task)
                    }
                }
           
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
               
                Text("Due: \(formattedDate(task.dueDate))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
               
                Text("Category: \(task.category.rawValue)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("Priority: \(task.priority.rawValue)")
                    .font(.caption)
                    .padding(6)
                    .background(priorityColor(for: task.priority).opacity(0.3))
                    .foregroundColor(priorityColor(for: task.priority))
                    .cornerRadius(6)
            }
           
            Spacer()
           
            Text(task.status.rawValue)
                .font(.caption)
                .padding(8)
                .background(statusColor(for: task.status).opacity(0.2))
                .foregroundColor(statusColor(for: task.status))
                .cornerRadius(5)
           
            editButton(for: task)
            
            
            deleteButton(for: task)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.vertical, 5)
    }
   
   
    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .overdue: return .red
        case .nearDue: return .orange
        case .pending: return .blue
        case .completed: return .green
        }
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case.medium: return .orange
        case .high: return .red
        }
    }
    
    private func deleteButton(for task: Task) -> some View {
        Button(action: {
            taskToEdit = nil
            taskViewModel.deleteTask(task: task)
        }) {
            Image(systemName: "trash.circle.fill")
                .foregroundColor(.red)
                .font(.title2)
                .shadow(radius: 2)
        }
    }
    
    private func deleteTask(task: Task) {
        if let index = taskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
            taskViewModel.tasks.remove(at: index)
           }
       }
    

    private func editButton(for task: Task) -> some View {
        Button(action: {
            taskToEdit = task
            isEditTaskPresented = true
        }) {
            Image(systemName: "pencil.circle.fill")
                .foregroundColor(.white)
                .font(.title2)
                .shadow(radius: 2)
        }
        
        .sheet(isPresented: $isEditTaskPresented) {
            AddTaskView(taskViewModel: taskViewModel, taskToEdit: $taskToEdit)
        }
    }

   
 
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
