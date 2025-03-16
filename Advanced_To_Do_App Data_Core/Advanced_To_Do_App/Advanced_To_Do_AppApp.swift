//
//  Advanced_To_Do_AppApp.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//
import SwiftUI

@main
struct Advanced_To_Do_AppApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var taskViewModel: TaskViewModel
    @StateObject var authViewModel: AuthViewModel

    @Environment(\.scenePhase) private var scenePhase

    init() {
        let context = persistenceController.container.viewContext
        let taskVM = TaskViewModel(context: context, user: nil) // Initialize first
        _taskViewModel = StateObject(wrappedValue: taskVM)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(context: context, taskViewModel: taskVM)) // Pass to AuthViewModel
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(taskViewModel)
                .environmentObject(authViewModel)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive || phase == .background {
                saveContext()
            }
        }
    }

    private func saveContext() {
        do {
            let context = persistenceController.container.viewContext
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
