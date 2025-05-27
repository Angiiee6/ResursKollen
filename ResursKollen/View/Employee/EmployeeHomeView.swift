//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @StateObject var viewModel: ViewModel
    @State private var isLoggedOut = false

    //Sends the current user directly to the view model
    init(currentUser: UserData) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(currentUser: currentUser)
        )
    }

    var body: some View {

        NavigationStack {

            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isLoggedOut) {
                EmptyView()
            }

            TabView {

                EmployeeMyOrders(viewModel: viewModel)
                    .tabItem {
                        Label(
                            "Mina Ordrar",
                            systemImage: "list.bullet.clipboard"
                        )
                    }

                EmployeeAllOrders(viewModel: viewModel)

                    .tabItem {
                        Label(
                            "Alla Ordrar",
                            systemImage: "list.bullet.clipboard"
                        )
                    }

                StaffView()

                    .tabItem {
                        Label("Personal", systemImage: "person.3")
                    }
            }.tint(Color.orange)
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
                    $0.assignedUser?.id == currentUser.id && $0.status != .done
                        && $0.status != .completed
                }
                self.unassignedOrders = orders.filter { $0.assignedUser == nil }
            }
        }

        ///Sets the order's `assignedUser` to the current user.
        func takeOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUser = currentUser
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error taking order!")
            }
        }

        ///Sets an order's `assignedUser` to `nil`.
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
