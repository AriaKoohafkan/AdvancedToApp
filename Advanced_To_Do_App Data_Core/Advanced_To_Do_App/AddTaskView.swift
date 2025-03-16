//
//  AddTaskView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var taskToEdit: Task?
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var category: TaskCategory = .personal
    @State private var priority: TaskPriority = .medium
    
    var selectedDate: Date?

    var body: some View {
        NavigationView {
            ZStack {
              
                LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.pink.opacity(0.6)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Form {
                        Section(header: 
                                    HStack {
                            Spacer()
                            
                            Text("Task Details")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                            .foregroundColor(.pink.opacity(0.6))
                            .padding(.top, 10)) {

                            TextField("Task Title", text: $title)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .foregroundColor(.pink.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                                .font(.headline)

                        
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(15)
                                .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                            DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)

                           
                            Picker("Category", selection: $category) {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                        }

                      
                        Section {
                            HStack {
                                Spacer()
                                Text("Priority")
                                    .font(.headline)
                                    .foregroundColor(.pink.opacity(0.6))
                                Spacer()
                            }

                            Picker("Priority", selection: $priority) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    Text(priority.rawValue).tag(priority)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color.pink.opacity(0.3))
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 4)
                        }
                    }
                    .background(Color.pink)
                    .cornerRadius(15)
                }
                .padding()
            }
           
            .navigationTitle(taskToEdit == nil ? "Add Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
        
            .toolbar {
              
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        taskToEdit = nil
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                    }
                }

           
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveTask()
                    }) {
                        Text(taskToEdit == nil ? "Save" : "Update")
                            .fontWeight(.bold)
                            .foregroundColor(title.isEmpty ? Color.gray : Color.blue)
                            .padding()
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                if let taskToEdit = taskToEdit {
                    title = taskToEdit.title
                    dueDate = taskToEdit.dueDate
                    category = taskToEdit.category
                    priority = taskToEdit.priority
                } else if let selectedDate = selectedDate {
                    dueDate = selectedDate
                }
            }
        }
    }
    

    private func saveTask() {
        if let taskToEdit = taskToEdit {
            taskViewModel.editTask(id: taskToEdit.id, title: title, dueDate: dueDate, category: category, priority: priority)
        } else {
            guard let user = authViewModel.user else { return }
            taskViewModel.addTask(title: title, dueDate: dueDate, category: category, priority: priority)
        }
        taskToEdit = nil
        presentationMode.wrappedValue.dismiss()
    }
}
