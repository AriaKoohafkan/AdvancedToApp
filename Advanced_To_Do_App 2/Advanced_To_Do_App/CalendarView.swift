//
//  CalendarView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghods Mohammadi on 2025-03-06.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date?
    @ObservedObject var taskViewModel: TaskViewModel

    var body: some View {
        VStack {
        
       
            CalendarGridView(selectedDate: $selectedDate, taskViewModel: taskViewModel)

            if let selectedDate = selectedDate {
                Text("Selected Date: \(formattedDate(selectedDate))")
                    .font(.title2)
                List {
                    let tasksForDate = taskViewModel.tasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
                    ForEach(tasksForDate) { task in
                        Text(task.title)
                    }
                }
            }
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
