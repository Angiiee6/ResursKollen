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

#Preview {
    NavigationStack {
        EmployeeStaffView(
            viewModel: EmployeeHomeView.ViewModel(
                currentUser: UserData(name: "Test user")
            )
        )
    }
}
