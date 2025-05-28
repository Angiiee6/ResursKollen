//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI

struct ManagerAllOrdersView: View {
    @ObservedObject var viewModel: ManagerHomeView.ViewModel
    @State var searchText: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            List {
                Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                    ForEach(filteredOrders(for: viewModel.registeredOrders)) { order in
                        NavigationLink(
                            destination: OrderDetailView(
                                order: order,
                                status: .manager
                            )
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    }
                }
                Section(
                    header: Text("Påbörjade ordrar").foregroundColor(.orange)
                ) {
                    ForEach(filteredOrders(for: viewModel.startedOrders)) { order in
                        NavigationLink(
                            destination: OrderDetailView(
                                order: order,
                                status: .manager
                            )
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    }
                }
                Section(header: Text("Försenade ordrar").foregroundColor(.red))
                {
                    ForEach(filteredOrders(for: viewModel.delayedOrders)) { order in
                        NavigationLink(
                            destination: OrderDetailView(
                                order: order,
                                status: .manager
                            )
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    }
                }
                Section(
                    header: Text("Avslutade ordrar").foregroundColor(.green)
                ) {
                    ForEach(filteredOrders(for: viewModel.completedOrders)) { order in
                        NavigationLink(
                            destination: OrderDetailView(
                                order: order,
                                status: .manager
                            )
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Sök bland ordrar")
        }
    }

    func filteredOrders(for orders: [Order]) -> [Order] {
        orders.filter {
            searchText.isEmpty
                || $0.customer.name.lowercased().contains(
                    searchText.lowercased()
                )
                || $0.orderNumber.lowercased().contains(
                    searchText.lowercased()
                )
        }
    }
}

#Preview {
    ManagerAllOrdersView(
        viewModel: ManagerHomeView.ViewModel(
            currentUser: UserData(name: "Test user")
        )
    )
}

