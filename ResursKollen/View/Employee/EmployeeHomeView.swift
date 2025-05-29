import Combine
//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @ObservedObject var dataProvider: AppDataProvider
    @StateObject var viewModel: ViewModel
    @State private var isLoggedOut = false

    init(dataProvider: AppDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(
            wrappedValue: ViewModel(dataProvider: dataProvider)
        )
    }

    var body: some View {
        NavigationStack {
            NavigationLink(
                destination: ContentView().navigationBarBackButtonHidden(true),
                isActive: $isLoggedOut
            ) {
                EmptyView()
            }

            TabView {
                EmployeeMyOrders(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Mina Ordrar",
                            systemImage: "list.bullet.clipboard"
                        )
                    }.badge(viewModel.myOrdersCount)

                EmployeeAllOrders(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Alla Ordrar",
                            systemImage: "list.bullet.clipboard"
                        )
                    }.badge(viewModel.unassignedOrdersCount)

                EmployeeStaffView(dataProvider: dataProvider)
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
        @Published var myOrdersCount: Int = 0
        @Published var unassignedOrdersCount: Int = 0

        private var cancellables = Set<AnyCancellable>()

        init(dataProvider: AppDataProvider) {
            self.currentUser = dataProvider.currentUser
            dataProvider.$activeOrders.sink { [weak self] allOrders in
                self?.myOrdersCount =
                    allOrders.filter {
                        $0.assignedUserId == dataProvider.currentUser.id
                        && $0.status != .completed
                        && $0.status != .done
                    }.count
                self?.unassignedOrdersCount =
                    allOrders.filter { $0.assignedUserId == nil }.count
            }
            .store(in: &cancellables)
        }

        deinit {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }

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

        //        TabView {
        //
        //            NavigationStack {
        //                EmployeeMyOrders(dataProvider: dataProvider)
        //            }
        //            .tabItem {
        //                Label("Mina Ordrar", systemImage: "list.bullet.clipboard")
        //            }
        //
        //            NavigationStack {
        //                EmployeeAllOrders(dataProvider: dataProvider)
        //
        //            }
        //            .tabItem {
        //                Label("Alla Ordrar", systemImage: "list.bullet.clipboard")
        //            }
        //
        //            NavigationStack {
        //                EmployeeStaffView(dataProvider: dataProvider)
        //
        //            }
        //            .tabItem {
        //                Label("Personal", systemImage: "person.3")
        //            }
        //        }.tint(Color.orange)
    }
}

#Preview {
    EmployeeHomeView(
        dataProvider: AppDataProvider(currentUser: UserData(name: "Test user"))
    )
}
