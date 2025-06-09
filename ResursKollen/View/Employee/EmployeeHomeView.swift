//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI
import Combine
import Factory

struct EmployeeHomeView: View {
//    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var viewModel = ViewModel()

//    init(dataProvider: MainDataProvider) {
//        self.dataProvider = dataProvider
//        _viewModel = StateObject(
//            wrappedValue: ViewModel(dataProvider: dataProvider)
//        )
//    }

    var body: some View {
        
        TabView {
            NavigationStack {
                EmployeeMyOrders()
            }
            .tabItem {
                Label(
                    "Mina Ordrar",
                    systemImage: "list.bullet.clipboard"
                )
            }.badge(viewModel.myOrdersCount)
            
            NavigationStack {
                EmployeeAllOrders()
            }
            .tabItem {
                Label(
                    "Alla Ordrar",
                    systemImage: "list.bullet.clipboard"
                )
            }.badge(viewModel.unassignedOrdersCount)
            
            NavigationStack {
                EmployeeStaffView()
            }
            .tabItem {
                Label("Kontakter", systemImage: "person.3")
                }
            }
        }
    }


extension EmployeeHomeView {

    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.employeeDataProvider) var dataProvider: MainDataProvider
        @EnvironmentObject var loginViewModel: LoginViewViewmodel
        @Published var myOrdersCount: Int = 0
        @Published var unassignedOrdersCount: Int = 0

        private var cancellables = Set<AnyCancellable>()

        init() {
            dataProvider.$activeOrders.sink { [weak self] allOrders in
                self?.myOrdersCount =
                    allOrders.filter {
                        fatalError("Don't use env obj in view models!")
                        $0.assignedUserId == self?.loginViewModel.currentUser?.id
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
    EmployeeHomeView()
}
