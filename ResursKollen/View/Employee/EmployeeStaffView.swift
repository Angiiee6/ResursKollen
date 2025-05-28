//
//  EmployeeStaffView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import SwiftUI

struct EmployeeStaffView: View {
    @EnvironmentObject var appData: AppData
    @StateObject var viewModel = ViewModel()

    

    var body: some View {
        VStack {
            StaffView(currentUser: appData.currentUser)
            EmployeeMonthlySummaryDisplay(
                hoursWorkedThisMonth: viewModel.hoursWorkedThisMonth
            )
        }
        onAppear {
            viewModel.setup(appData: appData)
        }
    }
}

extension EmployeeStaffView {

    class ViewModel: ObservableObject {
        @Published var hoursWorkedThisMonth: Double = 0

        func setup(appData: AppData) {
            appData.$allOrders.map { orders in
                orders
                    //Put all orders lists of time units into one list
                    .flatMap { $0.timeUnits }
                    //Selected only time added this month and for the current user
                    .filter {
                        $0.date.isThisMonth
                            && $0.userId == appData.currentUser.id
                    }
                    //Create new list with only the time (doubles)
                    .map { $0.time }
                    //Sum all time
                    .reduce(0, +)
            }
            .assign(to: &$hoursWorkedThisMonth)
        }

    }

}

//#Preview {
//    NavigationStack {
//        EmployeeStaffView(
//            viewModel: EmployeeHomeView.ViewModel(
//                currentUser: UserData(name: "Test user")
//            )
//        )
//    }
//}
