//
//  ContentView.swift
//  ResursKollen
//
//  Created by Angelica E on 2025-05-14.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = LoginViewViewmodel()

    var body: some View {

        if let user = viewModel.currentUser {
            let appdataProvider = AppDataProvider(currentUser: user)
            switch user.status {
            case .manager:
                ManagerHomeView(dataProvider: appdataProvider)
            case .employee:
                EmployeeHomeView(dataProvider: appdataProvider)

            //            case .unknown:
            //                Text("Unknown user!")
            }
        } else {
            LoginView(viewModel: viewModel)
        }

    }
}



#Preview {
    ContentView()
}
