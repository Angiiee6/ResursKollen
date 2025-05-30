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
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isLoggedOut){
                EmptyView()
            }.navigationBarBackButtonHidden(true)
            
            TabView {
                ManagerAllOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label("Aktiva ordrar", systemImage: "list.bullet.clipboard")
                    }
                ReviewOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Utförda ordrar",
                            systemImage: "text.page.badge.magnifyingglass"
                        )
                    }
                SummaryView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Statistik",
                            systemImage: "waveform.badge.magnifyingglass"
                        )
                    }
                StaffView(currentUser: dataProvider.currentUser)
                    .tabItem {
                        Label("Personal", systemImage: "person.3")
                    }
            
                 NewMessageEditView()
                    .tabItem{
                        Label("Meddlanden", systemImage: "message")
                    }
            }
            //            NavigationStack {
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
                //            .tabItem {
                //                Label("Personal", systemImage: "person.3")
                //
                //        }
                //        .tint(Color.orange)
            }
        }
    }
}

//TODO: Fetch all orders here instead of in sub-views

//TODO: Fetch all orders here instead of in sub-views

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
    ManagerHomeView(dataProvider: MainDataProvider.asPreview())
}
