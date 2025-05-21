//
//  EmployeeAllOrders.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-21.
//

import SwiftUI

struct EmployeeAllOrders: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel

    var body: some View {
        List {
            Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                ForEach(
                    viewModel.unassignedOrders.filter {
                        $0.status == .registered
                    }
                ) {
                    order in
                    NavigationLink(
                        destination: OrderDetailView(order: order)
                    ) {
                        OrderRowAllOrders(order: order)

                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.takeOrder(order)
                                } label: {
                                    Label(
                                        "Ta order",
                                        systemImage: "hand.wave.fill"
                                    )
                                }
                                .tint(.yellow)
                            }

                    }

                }
            }
            Section(
                header: Text("Påbörjade ordrar").foregroundColor(.orange)
            ) {
                ForEach(
                    viewModel.unassignedOrders.filter { $0.status == .started }
                ) {
                    order in
                    NavigationLink(
                        destination: OrderDetailView(order: order)
                    ) {
                        OrderRowAllOrders(order: order)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.takeOrder(order)
                                } label: {
                                    Label(
                                        "Ta order",
                                        systemImage: "hand.wave.fill"
                                    )
                                }
                                .tint(.yellow)
                            }
                    }
                }
            }
            Section(header: Text("Försenade ordrar").foregroundColor(.red)) {
                ForEach(
                    viewModel.unassignedOrders.filter { $0.status == .delayed }
                ) {
                    order in
                    NavigationLink(
                        destination: OrderDetailView(order: order)
                    ) {
                        OrderRowAllOrders(order: order)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.takeOrder(order)
                                } label: {
                                    Label(
                                        "Ta order",
                                        systemImage: "hand.wave.fill"
                                    )
                                }
                                .tint(.yellow)
                            }
                    }
                }
            }

            Section(
                header: Text("Avslutade ordrar").foregroundColor(.green)
            ) {
                ForEach(
                    viewModel.unassignedOrders.filter {
                        $0.status == .completed
                    }
                ) {
                    order in
                    NavigationLink(
                        destination: OrderDetailView(order: order)
                    ) {
                        OrderRowAllOrders(order: order)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Alla ordrar")
        // .searchable(text: .constant(""), prompt: "Sök bland ordrar")
    }
}

#Preview {
    EmployeeAllOrders(viewModel: EmployeeHomeView.ViewModel(currentUser: UserData(name: "Test user")))
}
