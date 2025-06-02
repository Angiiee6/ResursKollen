//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @State private var isLoggedOut = false
    @State private var showMoreNav = false
    @State private var selected = 0
    @State private var navToMessage = false
    @State private var navToMaterial = false
    

    var body: some View {
        NavigationStack {
       
            TabView(selection: $selected) {
                ManagerAllOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Aktiva ordrar",
                            systemImage: "list.bullet.clipboard")
                        
                    }.tag(0)
                
                ReviewOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Utförda ordrar",
                            systemImage: "text.page.badge.magnifyingglass"
                        )
                    }.tag(1)
                
                SummaryView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Statistik",
                            systemImage: "waveform.badge.magnifyingglass"
                        )
                    }.tag(2)
                
                StaffView(currentUser: dataProvider.currentUser)
                    .tabItem {
                        Label("Personal", systemImage: "person.3")
                    }.tag(3)
             
                
                Text("litemer")
                    .tabItem{
                        Label("mera", systemImage: "ellipsis.circle")
                    }.tag(5)
                    .onChange(of: selected){
                        if selected == 5{
                            showMoreNav = true
                            selected = 0
                            print("Händer saker")
                        }
                    }
                
                
            }
            .confirmationDialog("Välj", isPresented: $showMoreNav) {
                Button("Meddelande till anställda"){
                    navToMessage = true
                }
                .navigationDestination(isPresented: $navToMessage) {
                    NewMessageEditView()
                }
                
                Button("Material"){
                    navToMaterial = true
                }
                
            }
            .tint(Color.orange)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        do {
                            try AuthenticationManager.shared.signOut()
                            isLoggedOut = true
                        } catch {
                            print("Kunde inte logga ut användaren")
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .tint(.orange)
                    }
                }
            }
            .navigationDestination(isPresented: $navToMessage) {
                NewMessageEditView()
            }
            .navigationDestination(isPresented: $navToMaterial) {
                MaterialHomeView()
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                ContentView().navigationBarBackButtonHidden(true)
            }
        }
        
    }
}

#Preview {
    ManagerHomeView(dataProvider: MainDataProvider.asPreview())
}

