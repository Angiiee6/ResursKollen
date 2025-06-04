//
//  ContentView.swift
//  ResursKollen
//
//  Created by Angelica E on 2025-05-14.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel : LoginViewViewmodel

    var body: some View {

        if let user = viewModel.currentUser {
            switch user.status {
            case .manager:
                let dataProvider = MainDataProviderBuilder(currentUser: user)
                    .withActiveOrders()
                    .withCompletedOrders()
                    .withAllCustomers()
                    .build()
                ManagerHomeView(
                    dataProvider: dataProvider
                )
            case .employee:
                let dataProvider = MainDataProviderBuilder(currentUser: user)
                    .withActiveOrders()
                    .withCompletedOrders()
                    .build()
                EmployeeHomeView(dataProvider: dataProvider)
            }
        } else {
            LoginView(viewModel: viewModel)
        }

    }
}

#Preview {
    ContentView()
        .environmentObject(LoginViewViewmodel())
}
