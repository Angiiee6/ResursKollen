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
    
        if !viewModel.isUserLoggedIn {
            LoginView(viewModel: viewModel)
                
        }else {
            if viewModel.isUserManager {
                ManagerHomeView()
                    
            }else {
                
                    
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
