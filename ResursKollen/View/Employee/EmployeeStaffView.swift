//
//  EmployeeStaffView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import SwiftUI

struct EmployeeStaffView: View {
    @ObservedObject var dataProvider: AppData
    @StateObject var viewModel : ViewModel

    init(dataProvider: AppData) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(wrappedValue: ViewModel(dataProvider: dataProvider))
    }
    

    var body: some View {
        VStack {
            StaffView(currentUser: dataProvider.currentUser)
            EmployeeMonthlySummaryDisplay(
                hoursWorkedThisMonth: viewModel.hoursWorkedThisMonth
            )
        }
    }
}

extension EmployeeStaffView {

    class ViewModel: ObservableObject {
        @Published var hoursWorkedThisMonth: Double = 0

        init(dataProvider: AppData) {
            dataProvider.$allOrders.map { orders in
                orders
                    //Put all orders lists of time units into one list
                    .flatMap { $0.timeUnits }
                    //Selected only time added this month and for the current user
                    .filter {
                        $0.date.isThisMonth
                            && $0.userId == dataProvider.currentUser.id
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
