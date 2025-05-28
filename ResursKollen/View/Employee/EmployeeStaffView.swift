//
//  EmployeeStaffView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import SwiftUI

struct EmployeeStaffView: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel

    var body: some View {
        ZStack {
            // Gradientbakgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                StaffView(currentUser: viewModel.currentUser)
                EmployeeMonthlySummaryDisplay(
                    hoursWorkedThisMonth: viewModel.myTimeUnitsThisMonth.map {
                        $0.time
                    }.reduce(0, +)
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmployeeStaffView(
            viewModel: EmployeeHomeView.ViewModel(
                currentUser: UserData(name: "Test user")
            )
        )
    }
}
