//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    @EnvironmentObject var appData: AppData

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
                StaffView(currentUser: appData.currentUser)
            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
            }
        }
        .tint(Color.orange)
    }
}

//extension ManagerHomeView {
//
//    class ViewModel: ObservableObject {
//        let currentUser: UserData
//        
//        @Published var registeredOrders: [Order] = []
//        @Published var startedOrders: [Order] = []
//        @Published var delayedOrders: [Order] = []
//        @Published var completedOrders: [Order] = []
//
//        init(currentUser: UserData) {
//            self.currentUser = currentUser
//            listenToOrderCollection()
//        }
//        
//        func listenToOrderCollection() {
//            FirestoreManager.shared.listenToOrderCollection { [weak self] newOrders in
//                DispatchQueue.main.async {
//                    self?.registeredOrders = newOrders.filter {$0.status == .registered}
//                    self?.startedOrders = newOrders.filter {$0.status == .started}
//                    self?.delayedOrders = newOrders.filter {$0.status == .delayed}
//                    self?.completedOrders = newOrders.filter {$0.status == .completed}
//                    
//                }
//            }
//        }
//        
//        
//    }
//
//}

#Preview {
    ManagerHomeView()
}
