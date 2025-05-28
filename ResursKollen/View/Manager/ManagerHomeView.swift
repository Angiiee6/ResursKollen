//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    let currentUser: UserData

    @State private var isLoggedOut = false
    ///EXEMPEL USER
    let exampleUser = UserData(
        id: "1",
        status: .employee,
        name: "Vivianne och Angie",
        employmentDate: Date(),
        employmentNumber: "EMP123",
        phoneNumber: "0701234567"
    )

    var body: some View {
        NavigationStack{
            
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isLoggedOut){
                EmptyView()
            }.navigationBarBackButtonHidden(true)
            
            TabView {
                
                ManagerAllOrdersView()
                
                    .tabItem {
                        Label("Aktiva ordrar", systemImage: "list.bullet.clipboard")
                    }
                
                ReviewOrdersView()
                
                    .tabItem {
                        Label(
                            "Utförda ordrar",
                            systemImage: "text.page.badge.magnifyingglass"
                        )
                    }
                
                SummaryView()
                
                
                    .tabItem {
                        Label(
                            "Statistik",
                            systemImage: "waveform.badge.magnifyingglass"
                        )
                    }
                
                StaffView(currentUser: currentUser)
                
                    .tabItem {
                        Label("Personal", systemImage: "person.3")
                    }
                NewMessageEditView()
                    .tabItem{
                        Label("Meddlanden", systemImage: "message")
                    }
                
            }
            .tint(Color.orange)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        do{
                            try AuthenticationManager.shared.signOut()
                            isLoggedOut = true
                        }catch {
                            print("Kunde inte logga ut användaren")
                        }
                    }label: {
                     Image(systemName: "rectangle.portrait.and.arrow.right")
                            .tint(.orange)
                    }
                }
            }
        }
       
    }
    
}

//TODO: Fetch all orders here instead of in sub-views


#Preview {
    ManagerHomeView(currentUser: UserData(name: "Test user"))
}
