//
//  WelcomeView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghodsmohmmadi on 2025-03-02.
//

import SwiftUI

// Step 1: Create the Welcome View
struct WelcomeView: View {
    @State private var isActive: Bool = false
   
    var body: some View {
        VStack {
            
            if isActive {
             
                ContentView()
            } else {
            
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.3)]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                   
                    VStack {
                        Image("Welcome-Image")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(20)
                        
                        Text("Welcome to Tickit")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Team Members: Pegah Ghods Mohammadi, Aria Koohafkan")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .padding()

                  
                        Text("Loading...")
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    }
                }
                .onAppear {
              
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

