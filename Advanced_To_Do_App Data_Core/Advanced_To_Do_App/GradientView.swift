//
//  GradientView.swift
//  Advanced_To_Do_App
//
//  Created by Pegah Ghods Mohammadi on 2025-03-06.
//

import Foundation
import SwiftUI

struct GradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#c9e4ca"),
                Color(hex: "#87bba2"),
                Color(hex: "#55828b"),
                Color(hex: "#3b6064"),
                Color(hex: "#364958")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
    
    
   
    extension Color {
        init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 6: // RGB (no alpha)
                (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
            case 8: // ARGB
                (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
            
        }
    }

