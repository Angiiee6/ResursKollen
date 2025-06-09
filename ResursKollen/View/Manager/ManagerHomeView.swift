//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
//    @ObservedObject var dataProvider: MainDataProvider
    @State private var isLoggedOut = false
    @EnvironmentObject var loginViewModel: LoginViewViewmodel
    
    var body: some View {
        
        TabView {
            NavigationStack {
                ManagerAllOrdersView()
            }
            .tabItem {
                Label(
                    "Aktiva ordrar",
                    systemImage: "list.bullet.clipboard"
                )
            }
            NavigationStack {
                ReviewOrdersView()
            }
            .tabItem {
                Label(
                    "Utförda ordrar",
                    systemImage: "text.page.badge.magnifyingglass"
                )
            }
            NavigationStack {
                SummaryView()
            }
            .tabItem {
                Label(
                    "Statistik",
                    systemImage: "waveform.badge.magnifyingglass"
                )
            }
            NavigationStack {
                StaffView(currentUser: loginViewModel.currentUser ?? UserData())
            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
            }
            
            NavigationStack {
                NewMessageEditView()
            }
                    .tabItem {
                        Label("Meddlanden", systemImage: "message")
                    }
            
            .tint(Color.orange)
        }
    }
}

#Preview {
    ManagerHomeView()
}
