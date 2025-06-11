//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewViewmodel
   
    @State private var isLoggedOut = false
    @State private var showMoreNav = false
    @State private var selected = 0
    @State private var navToOrdersDone = false
    @State private var navToMessage = false
    @State private var navToMaterial = false
    @State private var navToCusomer = false

    //MARK: Body
    var body: some View {
        NavigationStack {
            TabView(selection: $selected) {
                NavigationStack {
                    ManagerAllOrdersView()
                }
                .tabItem {
                    Label("Aktiva ordrar", systemImage: "list.bullet.clipboard")
                }
                .tag(0)

                NavigationStack {
                    ReviewOrdersView()
                }
                .tabItem {
                    Label(
                        "Utförda ordrar",
                        systemImage: "text.page.badge.magnifyingglass"
                    )
                }
                .tag(1)

                NavigationStack {
                    SummaryView()
                }
                .tabItem {
                    Label(
                        "Statistik",
                        systemImage: "waveform.badge.magnifyingglass"
                    )
                }
                .tag(2)

                NavigationStack {
                    StaffView(currentUser: loginViewModel.currentUser ?? UserData())
                }
                .tabItem {
                    Label("Personal", systemImage: "person.3")
                }
                .tag(3)

                NavigationStack {
                    Text("fler alternativ")
                }
                .tabItem {
                    Label("Mera", systemImage: "ellipsis.circle")
                }
                .tag(5)
            }
            .onChange(of: selected, initial: false){ oldvalue, newValue  in
                if newValue == 5 {
                    showMoreNav = true
                    selected = 0  // Hoppar tillbaka till första fliken
                  
                }
            }
            .tint(.orange)
            //MARK: Show more navbar
            .confirmationDialog("Välj", isPresented: $showMoreNav) {
                
                
                Button("Avslutade arbetsordrar"){
                    navToOrdersDone = true
                }
                Button("Meddelande till anställda") {
                    navToMessage = true
                }
                Button("Material") {
                    navToMaterial = true
                }
                Button("Kunder")
                {
                    navToCusomer = true
                }
            }
            .navigationDestination(isPresented: $navToOrdersDone) {
               CompletedOrders()
            }
            .navigationDestination(isPresented: $navToCusomer) {
               CustomerView()
            }
            .navigationDestination(isPresented: $navToMessage) {
                NewMessageEditView()
            }
            .navigationDestination(isPresented: $navToMaterial) {
                MaterialHomeView().navigationBarBackButtonHidden(false)
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                ContentView().navigationBarBackButtonHidden(true)
            }

        }
    }

}

#Preview {
    ManagerHomeView()
}

