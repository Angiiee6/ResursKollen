//
//  EmployeeStaffView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import Combine
import SwiftUI
import Factory

struct EmployeeStaffView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var loginViewModel: LoginViewViewmodel

    var body: some View {
        BaseView {
            VStack {
                StaffView(currentUser: loginViewModel.currentUser ?? UserData())
                EmployeeMonthlySummaryDisplay(
                    hoursWorkedThisMonth: viewModel.hoursWorkedThisMonth
                )
            }
        }
    }
}

extension EmployeeStaffView {

    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.employeeDataProvider) var dataProvider: MainDataProvider
        @Published var hoursWorkedThisMonth: Double = 0

        init() {
            let ordersPublisher = Publishers.CombineLatest(
                dataProvider.$activeOrders,
                dataProvider.$completedOrders
            )

            let timeWorkedPublisher =
                ordersPublisher
                .map { active, completed in
                    let allOrders = active + completed
                    //Turn list of lists into one single list
                    let timeUnits = allOrders.flatMap { $0.timeUnits }

                    return
                        timeUnits
                        //Select only dates this month and for the current user
                        .filter {
                            $0.date.isThisMonth && $0.userId == self.dataProvider.currentUser.id
                        }
                        //Use only the time
                        .map { $0.time }
                        //Sum all time
                        .reduce(0, +)
                }

            timeWorkedPublisher
                .assign(to: &$hoursWorkedThisMonth)
            
        }
        
    }
}

#Preview {
    NavigationStack {
        EmployeeStaffView()
    }
}
