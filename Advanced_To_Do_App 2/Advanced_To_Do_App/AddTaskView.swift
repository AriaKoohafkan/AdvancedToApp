//
//  AddTaskView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import Foundation

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var taskToEdit: Task?
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var category: TaskCategory = .personal
    @State private var selectedPriority: TaskPriority = .medium

    var body: some View {
        ZStack {
            // 🔲 Background Gradient with Blur Effect
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)

            VStack {
                // 📌 Glassmorphic Task Form
                VStack(spacing: 18) {
                    Text(taskToEdit == nil ? "Add Task" : "Edit Task")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    // ✍️ Task Title
                    CustomTextField(placeholder:"Task Title", text: $title)

                    // 📅 Due Date & Time Pickers
                    VStack(spacing: 12) {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                            .customDatePickerStyle()

                        DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                            .customDatePickerStyle()
                    }

                    // 🔥 Priority Picker (Segmented Control)
                    VStack(alignment: .leading) {
                        Text("Priority")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(TaskPriority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // 📌 Category Picker
                    VStack(alignment: .leading) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Picker("Category", selection: $category) {
                            ForEach(TaskCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .padding(.top, 50)

                Spacer()

                // 🎯 Save/Update Button
                Button(action: saveTask) {
                    Text(taskToEdit == nil ? "Save Task" : "Update Task")
                        .font(.headline)
                        .frame(width: 250, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                   startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .scaleEffect(title.isEmpty ? 0.95 : 1.0)
                        .animation(.spring(), value: title)
                }
                .padding(.bottom, 30)
                .disabled(title.isEmpty)
            }
        }
        .onAppear {
            if let task = taskToEdit {
                title = task.title
                dueDate = task.dueDate
                category = task.category
                selectedPriority = task.priority
            }
        }
    }

    // 📌 Save Task Function
    private func saveTask() {
        if let taskToEdit = taskToEdit {
            taskViewModel.editTask(id: taskToEdit.id, title: title, dueDate: dueDate, priority: selectedPriority, category: category)
        } else {
            taskViewModel.addTask(title: title, dueDate: dueDate, category: category, priority: selectedPriority)
        }
        taskToEdit = nil
        presentationMode.wrappedValue.dismiss()
    }
}

// 🎨 Custom DatePicker Styling
extension View {
    func customDatePickerStyle() -> some View {
        self
            .padding()
           
            .cornerRadius(12)
            .shadow(radius: 3)
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

// 🎯 Custom Text Field Component
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
           
            .cornerRadius(12)
            .shadow(radius: 3)
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}
