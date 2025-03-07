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
    @State private var showingTaskDetails = false
    @State private var tasksForSelectedDate: [Task] = []
    
    @State private var currentMonth: Date = Date()  

    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let currentMonthComponents = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstDayOfMonth = calendar.date(from: currentMonthComponents)!
        
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startDate = calendar.date(byAdding: .day, value: -(weekday - 1), to: firstDayOfMonth)!
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        
        return (0..<(range.count + weekday - 1)).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
    }

    private var taskDates: [String: [Task]] {
        var taskDatesDict = [String: [Task]]()
        for task in taskViewModel.tasks {
            let formattedDate = formattedDate(task.dueDate)
            if taskDatesDict[formattedDate] == nil {
                taskDatesDict[formattedDate] = []
            }
            taskDatesDict[formattedDate]?.append(task)
        }
        return taskDatesDict
    }

    var body: some View {
        ZStack {
            Color.pink.opacity(0.1)
                .cornerRadius(16)
                .shadow(radius: 15)
            
            VStack {
                HStack {
                    Button(action: {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.pink.opacity(0.9))
                    }
                    
                    Text(self.currentMonthString)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.pink.opacity(0.9))
                        .padding()
                    
                    Button(action: {
                        
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .foregroundColor(.pink.opacity(0.9))
                    }
                    Spacer()
                }
                
                let rows = daysInMonth.chunked(into: 7)
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { date in
                            Text(self.dayOfMonth(for: date))
                                .frame(width: 40, height: 40)
                                .background(self.taskColor(for: date))
                                .foregroundColor(self.foregroundColor(for: date))
                                .clipShape(Circle())
                                .overlay(
                                    self.isToday(date) ? Circle().stroke(Color.blue, lineWidth: 2) : nil
                                )
                                .shadow(radius: 2)
                                .font(.headline)
                                .foregroundColor(.pink.opacity(0.4))
                                .onTapGesture {
                                    if let tasks = self.taskDates[formattedDate(date)] {
                                        self.tasksForSelectedDate = tasks
                                        self.showingTaskDetails = true
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 5)
                    .foregroundColor(.pink)
                }
                
                if showingTaskDetails {
                    VStack {
                        Spacer()
                        TaskDetailView(tasks: tasksForSelectedDate, showingTaskDetails: $showingTaskDetails)
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    }
                    .background(Color.black.opacity(0.3).onTapGesture {
                        self.showingTaskDetails = false
                    })
                }
            }
            .padding()
        }
    }

    private func dayOfMonth(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func isTaskDay(_ date: Date) -> Bool {
        let formattedDate = formattedDate(date)
        return taskDates[formattedDate] != nil
    }
    
    private func foregroundColor(for date: Date) -> Color {
        let formattedDate = formattedDate(date)
        
        if let tasks = taskDates[formattedDate], !tasks.isEmpty {
        
            return .white
        } else {
        
            return .pink.opacity(0.5)
        }
    }

    private func taskColor(for date: Date) -> Color {
        let formattedDate = formattedDate(date)
        if let tasks = taskDates[formattedDate], !tasks.isEmpty {
            return priorityColor(for: tasks.first!.priority)
        } else {
            return Color.clear
        }
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

    private func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private var currentMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
