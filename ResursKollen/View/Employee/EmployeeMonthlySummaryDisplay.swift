//
//  EmployeeMonthlySummaryDisplay.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import SwiftUI

struct EmployeeMonthlySummaryDisplay: View {
    let hoursWorkedThisMonth: Double
    let goalHours: Double = 160

    var progress: Double {
        min(hoursWorkedThisMonth / goalHours, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Arbetade timmar denna månad:")
                .font(.headline)
                .foregroundColor(.white)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 20)
                    .foregroundColor(Color.white.opacity(0.1))
               

                RoundedRectangle(cornerRadius: 12)
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.8, height: 20)
                    .foregroundColor(.orange)
                    .animation(.easeInOut, value: progress)
                
            }

            Text("\(Int(hoursWorkedThisMonth)) / \(Int(goalHours)) timmar")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0,
            y: 3)
        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                            )
        .padding(.horizontal)
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
    
}

#Preview {
    EmployeeMonthlySummaryDisplay(hoursWorkedThisMonth: 15.5)
}
