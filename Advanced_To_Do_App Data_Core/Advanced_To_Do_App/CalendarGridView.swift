//
//  CalendarGridView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghods Mohammadi on 2025-03-06.


import Foundation
import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date?
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showingAddTask = false
    @State private var currentMonth: Date = Date()
    @State private var showingTaskPreview = false
    @State private var tasksForSelectedDate: [Task] = []
   
    private let calendar = Calendar.current
   
    // MARK: - Computed Properties
   
    private var daysInMonth: [Date] {
        guard
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
            let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)
        else { return [] }
       
        let weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        let startDate = calendar.date(byAdding: .day, value: -weekday, to: firstDayOfMonth)!
        return (0..<range.count + weekday).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
    }
   
    private var taskDates: [String: [Task]] {
        Dictionary(grouping: taskViewModel.tasks) { task in
            formattedDate(task.dueDate)
        }
    }
   
    private var currentMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
   
    // MARK: - Body
   
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [.pink.opacity(0.2), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
           
            VStack(spacing: 16) {
                // Header
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.pink)
                    }
                   
                    Spacer()
                   
                    Text(currentMonthString)
                        .font(.title.bold())
                        .foregroundColor(.pink)
                   
                    Spacer()
                   
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.pink)
                    }
                }
                .padding(.horizontal)
               
                // Weekdays Label
                HStack(spacing: 0) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.pink.opacity(0.7))
                    }
                }
               
                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8) {
                    ForEach(daysInMonth, id: \.self) { date in
                        DayCell(
                            date: date,
                            tasks: taskDates[formattedDate(date)] ?? [],
                            isSelected: isToday(date),
                            onTap: {
                                let tasksForDate = taskDates[formattedDate(date)] ?? []
                                if !tasksForDate.isEmpty {
                                    tasksForSelectedDate = tasksForDate
                                    showingTaskPreview = true
                                } else {
                                    selectedDate = date
                                    showingAddTask = true
                                }
                            }
                        )
                    }
                }
                .padding(.vertical)
               
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(taskViewModel: taskViewModel, taskToEdit: .constant(nil), selectedDate: selectedDate)
        }
        .overlay(
            Group {
                if showingTaskPreview {
                    TaskPreviewCard(tasks: tasksForSelectedDate, isShowing: $showingTaskPreview)
                }
            }
        )
    }
   
    // MARK: - Actions
   
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
   
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
   
    // MARK: - Helpers
   
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
   
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
}

// MARK: - DayCell Component

struct DayCell: View {
    let date: Date
    let tasks: [Task]
    let isSelected: Bool
    let onTap: () -> Void
   
    private let calendar = Calendar.current
   
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: isSelected ? 2 : 0)
                )
           
            if !tasks.isEmpty {
                Image(systemName: "flag.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.red)
                    .shadow(radius: 2)
            }
        }
        .onTapGesture(perform: onTap)
        .scaleEffect(tasks.isEmpty ? 1 : 1.1) 
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: tasks.isEmpty)
    }
}

// MARK: - TaskPreviewCard Component

struct TaskPreviewCard: View {
    let tasks: [Task]
    @Binding var isShowing: Bool
   
    var body: some View {
        VStack(spacing: 16) {
            Text("Tasks for Today")
                .font(.title2.bold())
                .foregroundColor(.pink)
                .padding(.top)
           
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tasks, id: \.id) { task in
                        TaskRow(task: task)
                    }
                }
                .padding()
            }
           
            HStack {
                Spacer()
                Button(action: {
                    isShowing = false
                }) {
                    Text("Close")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            isShowing = false
        }
    }
}

// MARK: - TaskRow Component

struct TaskRow: View {
    let task: Task
   
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(task.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Circle()
                .fill(priorityColor(for: task.priority))
                .frame(width: 10, height: 10)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(priorityColor(for: task.priority).opacity(0.1))
        )
    }
   
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
}
