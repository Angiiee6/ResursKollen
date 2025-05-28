//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @ObservedObject var dataProvider: AppData
    @State private var isLoggedOut = false




        NavigationStack {
            
            NavigationLink(
                destination: ContentView().navigationBarBackButtonHidden(true),
                isActive: $isLoggedOut
            ) {
                EmptyView()
            }
            
            TabView {
                    EmployeeMyOrders(viewModel: viewModel)
                        .tabItem {
                            Label(
                                "Mina Ordrar",
                                systemImage: "list.bullet.clipboard")
                        }.badge(viewModel.myOrders.count)
                
                    EmployeeAllOrders(viewModel: viewModel)
                        .tabItem {
                            Label(
                                "Alla Ordrar",
                                systemImage: "list.bullet.clipboard"
                            )
                        }.badge(viewModel.unassignedOrders.count)
                    
                    EmployeeStaffView(viewModel: viewModel)
                        .tabItem {
                            Label("Personal", systemImage: "person.3")
                        }
                }
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
                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )
                            .tint(.orange)
                        }
                    }
                }
            }.tint(Color.orange)
        
        }

}


extension EmployeeHomeView {

    class ViewModel: ObservableObject {
        let currentUser: UserData
        @Published var myOrders: [Order] = []
        @Published var unassignedOrders: [Order] = []
        @Published var myTimeUnitsThisMonth: [OrderTimeUnit] = []

        init(currentUser: UserData) {
            self.currentUser = currentUser
            FirestoreManager.shared.listenToOrderCollection { orders in
                self.myOrders = orders.filter {
                    $0.assignedUserId == currentUser.id && $0.status != .done
                        && $0.status != .completed
                }
                self.unassignedOrders = orders.filter {
                    $0.assignedUserId == nil
                }

                let allTimeUnits = orders.flatMap { $0.timeUnits }
                let filteredTimeUnits = allTimeUnits.filter {
                    $0.userId == currentUser.id && $0.date.isThisMonth
                }
                self.myTimeUnitsThisMonth = filteredTimeUnits

            }
        }

        ///Sets the order's `assignedUserId` to the current user's id.
        func takeOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUserId = currentUser.id
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error taking order!")
            }
        }

        ///Sets an order's `assignedUserId` to `nil`.
        func leaveOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUserId = nil
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error leaving order!")
            }
        }

        TabView {

            NavigationStack {
                EmployeeMyOrders(dataProvider: dataProvider)
            }
            .tabItem {
                Label("Mina Ordrar", systemImage: "list.bullet.clipboard")
            }

            NavigationStack {
                EmployeeAllOrders(dataProvider: dataProvider)

            }
            .tabItem {
                Label("Alla Ordrar", systemImage: "list.bullet.clipboard")
            }

            NavigationStack {
                EmployeeStaffView(dataProvider: dataProvider)

            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
            }
        }.tint(Color.orange)
        }.tint(Color.orange)
    }
}

extension EmployeeHomeView {
    
   

//    class ViewModel: ObservableObject {
//        let currentUser: UserData
//        @Published var myOrders: [Order] = []
//        @Published var unassignedOrders: [Order] = []
//        @Published var myTimeUnitsThisMonth: [OrderTimeUnit] = []
//
//        init(currentUser: UserData) {
//            self.currentUser = currentUser
//            FirestoreManager.shared.listenToOrderCollection { orders in
//                self.myOrders = orders.filter {
//                    $0.assignedUserId == currentUser.id && $0.status != .done
//                        && $0.status != .completed
//                }
//                self.unassignedOrders = orders.filter {
//                    $0.assignedUserId == nil
//                }
//
//                let allTimeUnits = orders.flatMap { $0.timeUnits }
//                let filteredTimeUnits = allTimeUnits.filter {
//                    $0.userId == currentUser.id && $0.date.isThisMonth
//                }
//                self.myTimeUnitsThisMonth = filteredTimeUnits
//
//            }
//        }
//
//        ///Sets the order's `assignedUserId` to the current user's id.
//        func takeOrder(_ order: Order) {
//            var updatedOrder = order
//            updatedOrder.assignedUserId = currentUser.id
//            do {
//                try FirestoreManager.shared.updateOrder(updatedOrder)
//            } catch {
//                print("Error taking order!")
//            }
//        }
//
//        ///Sets an order's `assignedUserId` to `nil`.
//        func leaveOrder(_ order: Order) {
//            var updatedOrder = order
//            updatedOrder.assignedUserId = nil
//            do {
//                try FirestoreManager.shared.updateOrder(updatedOrder)
//            } catch {
//                print("Error leaving order!")
//            }
//        }
//
//    }
}

//#Preview {
//    EmployeeHomeView(currentUser: UserData(name: "Test user"))
//}
