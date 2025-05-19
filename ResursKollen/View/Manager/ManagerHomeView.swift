//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    var body: some View {
        NavigationStack {
            TabView {
                Tab("Ordrar", systemImage: "list.bullet") {
                    AllOrdersView()
                }
                Tab("Statistik", systemImage: "list.bullet.clipboard") {
                    SummaryView()
                }
                Tab("Personal", systemImage: "person.3") {
                    StaffDetailView()
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
