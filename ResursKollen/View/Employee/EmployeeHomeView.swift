import Combine
import Factory
//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @EnvironmentObject var loginViewModel: LoginViewViewmodel
    @StateObject var viewModel = ViewModel()

    var body: some View {
        //MARK: Body, tabview
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

//MARK: ViewModel
extension EmployeeHomeView {

    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.employeeDataProvider) var dataProvider: MainDataProvider
        @Published var myOrdersCount: Int = 0
        @Published var unassignedOrdersCount: Int = 0

        private var cancellables = Set<AnyCancellable>()

      
        
        init() {
            dataProvider.$activeOrders.sink { [weak self] allOrders in
                self?.myOrdersCount =
                allOrders.filter {
                    $0.assignedUserId == self?.dataProvider.currentUser.id
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
    }
}

#Preview {
    EmployeeHomeView()
}
