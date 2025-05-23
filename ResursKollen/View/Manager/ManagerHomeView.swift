//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {

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
                StaffView()
            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
                }
            }
        }
    }


#Preview {
    ManagerHomeView()
}
