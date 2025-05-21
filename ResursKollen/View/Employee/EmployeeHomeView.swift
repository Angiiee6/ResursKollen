//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @StateObject var viewModel: ViewModel

    init(currentUser: UserData) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(currentUser: currentUser)
        )
    }

    var body: some View {
        NavigationStack {
            TabView {
                Tab(
                    "Mina Ordrar",
                    systemImage:
                        "list.bullet.clipboard"
                ) {
                    //Filtrera på ordrar man äger
                    EmployeeMyOrders(
                        viewModel: viewModel
                    )
                }
                Tab(
                    "Alla Ordrar",
                    systemImage:
                        "list.bullet.clipboard"
                ) {
                    EmployeeAllOrders(viewModel: viewModel)
                }
                Tab("Personal", systemImage: "person.3") {
                    StaffView()
                }
            }
        }
    }
}

extension EmployeeHomeView {

    class ViewModel: ObservableObject {
        let currentUser: UserData
        @Published var myOrders: [Order] = []
        @Published var unassignedOrders: [Order] = []

        init(currentUser: UserData) {
            self.currentUser = currentUser

            FirestoreManager.shared.listenToOrderCollection { orders in
                self.myOrders = orders.filter {
                    $0.assignedUser?.id == currentUser.id
                }
                self.unassignedOrders = orders.filter { $0.assignedUser == nil }
            }
        }
        
        func takeOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUser = currentUser
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error taking order!")
            }
        }
        
        func leaveOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUser = nil
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
