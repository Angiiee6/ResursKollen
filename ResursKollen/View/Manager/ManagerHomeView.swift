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
        NavigationStack {
            TabView {
                Tab(
                    "Aktiva ordrar",
                    systemImage:
                        "list.bullet.clipboard"
                ) {
                    ManagerAllOrdersView()
                }
                Tab("Utförda ordrar", systemImage: "text.page.badge.magnifyingglass") {
                    ReviewOrdersView()
                }
                Tab(
                    "Statistik",
                    systemImage:
                        "waveform.badge.magnifyingglass"
                ) {
                    SummaryView()
                }

                Tab("Personal", systemImage: "person.3") {
                    // StaffView(user: exampleUser)
                    StaffView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateOrderView()
                    } label: {
                        Image(systemName: "plus")
                    }

                }

            }
        }
    }
}

#Preview {
    ManagerHomeView()
}
