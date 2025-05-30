//
//  EmployeeStaffView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import Combine
import SwiftUI

struct EmployeeStaffView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var viewModel: ViewModel

    init(dataProvider: MainDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(
            wrappedValue: ViewModel(dataProvider: dataProvider)
        )
    }

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
                StaffView(currentUser: dataProvider.currentUser)
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
        @Published var hoursWorkedThisMonth: Double = 0

        init(dataProvider: MainDataProvider) {
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
                    let currentUserId = dataProvider.currentUser.id

                    return
                        timeUnits
                        //Select only dates this month and for the current user
                        .filter {
                            $0.date.isThisMonth && $0.userId == currentUserId
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
        EmployeeStaffView(dataProvider: MainDataProvider.asPreview())
    }
}
