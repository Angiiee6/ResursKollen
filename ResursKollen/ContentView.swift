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
            switch user.status {
            case .manager:
                ManagerHomeView()
            case .employee:
                EmployeeHomeView(currentUser: user)
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
