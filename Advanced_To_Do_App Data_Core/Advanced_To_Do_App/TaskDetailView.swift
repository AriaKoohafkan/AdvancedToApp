//
//  TaskDetailView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghods Mohammadi on 2025-03-06.
//

import Foundation
import SwiftUI

struct TaskDetailView: View {
    var tasks: [Task]
    @Binding var showingTaskDetails: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer() 
                Button(action: {
                    self.showingTaskDetails = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.pink)
                        .padding(3)
                }
                .padding(.top, 10)
                .padding(.trailing, 10)
            }

            Text("Your Tasks:")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .foregroundColor(.pink.opacity(0.7))

         
            let sortedTasks = tasks.sorted { $0.priority.rawValue < $1.priority.rawValue }

            ForEach(sortedTasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    HStack {
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .foregroundColor(.pink.opacity(0.4))
                        Spacer()
                        Text(task.priority.rawValue)
                            .padding(6)
                            .background(self.priorityColor(for: task.priority))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    Text(task.status.rawValue)
                        .font(.subheadline)
                        .foregroundColor(task.status == .completed ? .green : .red)
                        .padding(.top, 4)

                    Text("Category: \(task.category.rawValue)")  
                        .foregroundColor(.secondary)
                        .padding(.top, 4)

                    Divider().padding(.vertical, 8)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
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
