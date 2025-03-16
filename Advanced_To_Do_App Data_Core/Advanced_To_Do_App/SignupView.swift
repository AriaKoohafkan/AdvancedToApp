//
//  SignupView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-15.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title
                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .shadow(radius: 5)

                // Username Field
                CustomTextField(placeholder: "Username", text: $username)

                // Password Field
                CustomSecureField(placeholder: "Password", text: $password)

                // Confirm Password Field
                CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)

                // Sign Up Button
                Button(action: {
                    if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        errorMessage = "All fields are required!"
                    } else if password != confirmPassword {
                        errorMessage = "Passwords do not match!"
                    } else if authViewModel.signUp(username: username, password: password) {
                        // Handle successful sign-up
                    } else {
                        errorMessage = "Username already exists."
                    }
                }) {
                    Text("Sign Up")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                }

                // Navigation to Login
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Log in")
                        .foregroundColor(.pink)
                        .fontWeight(.bold)
                }
                .padding()
            }
            .padding()
        }
    }
}

// Custom Styled TextField
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 3)
            .padding(.horizontal)
    }
}

// Custom Styled SecureField
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 3)
            .padding(.horizontal)
    }
}
