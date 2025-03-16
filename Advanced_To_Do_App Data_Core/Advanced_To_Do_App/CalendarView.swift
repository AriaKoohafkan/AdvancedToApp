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
