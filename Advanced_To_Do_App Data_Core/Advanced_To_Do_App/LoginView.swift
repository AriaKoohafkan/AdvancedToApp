//
//  LoginView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-15.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToSignUp = false
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                LinearGradient(colors: [Color.pink.opacity(0.6), Color.white], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // Username Field
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        .padding(.horizontal)

                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        .padding(.horizontal)

                    // Login Button
                    Button(action: {
                        authViewModel.login(username: username, password: password)
                    }) {
                        Text("Login")
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

                    // Sign Up Navigation
                    Button(action: {
                        navigateToSignUp = true
                    }) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.pink.opacity(0.6))
                            .fontWeight(.bold)
                    }

                    NavigationLink(destination: SignupView(), isActive: $navigateToSignUp) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }
}

