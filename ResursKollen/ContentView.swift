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
        
            switch viewModel.currentUser?.status {
            case .manager:
                ManagerHomeView()
            case .employee:
                EmployeeHomeView(currentUser: viewModel.currentUser!)
            case .unknown:
                Text("User status unknown!")
            case nil:
                LoginView(viewModel: viewModel)
            }
        }
        
        
    }


#Preview {
    ContentView()
}
