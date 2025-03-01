//
//  Advanced_To_Do_AppApp.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import SwiftUI
import UserNotifications

@main
struct Advanced_To_Do_AppApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted")
            }
        }
    }
}
