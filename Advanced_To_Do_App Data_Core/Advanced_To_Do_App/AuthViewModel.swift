//
//  AuthViewModel.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-15.
//

import Foundation
import CoreData

class AuthViewModel: ObservableObject {
    @Published var user: UserM?
    private let context: NSManagedObjectContext
    private var taskViewModel = TaskViewModel.shared
    
    init(context: NSManagedObjectContext, taskViewModel: TaskViewModel) {
        self.context = context
        self.taskViewModel = taskViewModel
    }
    
    func signUp(username: String, password: String) -> Bool {
        let request: NSFetchRequest<UserM> = UserM.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let existingUsers = try context.fetch(request)
            if !existingUsers.isEmpty { return false } // User already exists
            
            let newUser = UserM(context: context)
            newUser.id = UUID()
            newUser.username = username
            newUser.password = password // Hashing should be added for security
            
            saveContext()
            user = newUser
            return true
        } catch {
            print("Signup Error: \(error)")
            return false
        }
    }
    
    func login(username: String, password: String)  {
        let request: NSFetchRequest<UserM> = UserM.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try context.fetch(request)
            if let loggedInUser = users.first, loggedInUser.password == password {
                // Save the last logged-in user ID
                UserDefaults.standard.set(loggedInUser.id?.uuidString, forKey: "lastLoggedInUserID")
                
                // Notify TaskViewModel about the logged-in user
                taskViewModel.updateUser(newUser: loggedInUser)
                
                self.user = loggedInUser // Set the authenticated user
            } else {
                print("Invalid email or password")
            }
        } catch {
            print("Login error: \(error.localizedDescription)")
        }
    }
   
    func logout() {
        user = nil
    }
   
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

