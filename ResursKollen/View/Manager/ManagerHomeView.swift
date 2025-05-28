//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    let currentUser: UserData

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
        TabView {
            NavigationStack {
                ManagerAllOrdersView()
            }
            .tabItem {
                Label("Aktiva ordrar", systemImage: "list.bullet.clipboard")
            }
            

            NavigationStack {
                ReviewOrdersView()
            }
            .tabItem {
                Label("Utförda ordrar", systemImage: "text.page.badge.magnifyingglass")
            }

            NavigationStack {
                SummaryView()
            }
            .tabItem {
                Label("Statistik", systemImage: "waveform.badge.magnifyingglass")
            }

            NavigationStack {
                StaffView(currentUser: currentUser )
            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
                }
            }
        .tint(Color.orange)
        }
    }


//TODO: Fetch all orders here instead of in sub-views


#Preview {
    ManagerHomeView(currentUser: UserData(name: "Test user"))
}
