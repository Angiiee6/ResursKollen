//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @StateObject var viewModel: ViewModel

    //Sends the current user directly to the view model
    init(currentUser: UserData) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(currentUser: currentUser)
        )
    }

    var body: some View {
        TabView {

            NavigationStack {
                EmployeeMyOrders(viewModel: viewModel)
            }
            .tabItem {
                Label("Mina Ordrar", systemImage: "list.bullet.clipboard")
            }

            NavigationStack {
                EmployeeAllOrders(viewModel: viewModel)
            }
            .tabItem {
                Label("Alla Ordrar", systemImage: "list.bullet.clipboard")
            }

            NavigationStack {
                StaffView(userStatus: .employee)
            }
            .tabItem {
                Label("Personal", systemImage: "person.3")
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
                self.unassignedOrders = orders.filter { $0.assignedUserId == nil }

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

    }
}

#Preview {
    EmployeeHomeView(currentUser: UserData(name: "Test user"))
}
