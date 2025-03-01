//
//  WelcomeView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-02-28.
//

import Foundation

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToContent = false
   
    var body: some View {
        NavigationView {
            ZStack {
             
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
               
                VStack(spacing: 20) {
                  
                    Text("Welcome to the TaskManager")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                   
                
                    Text("Organize your tasks effortlessly and stay productive. Let's get started!")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                   
                   
                    NavigationLink(destination: ContentView(), isActive: $navigateToContent) {
                        Button(action: {
                            withAnimation {
                                navigateToContent = true
                            }
                        }) {
                            Text("Let's Start")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.top, 30)
                }
            }
        }
    }
}
