//
//  EmployeeAllOrders.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-21.
//

import SwiftUI

struct EmployeeAllOrders: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel
    @State var searchText : String = ""
    var body: some View {
        List {
            
            Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                ForEach(
                    filteredOrders(for: .registered).filter {
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
        .searchable(text: $searchText, prompt: "Sök bland ordrar")
        
    }
    //
    // tar in en status och filtrerar baserat på status sen använder vi sökordet för att filtrera i listan
    func filteredOrders(for status: OrderStatus) -> [Order] {
        viewModel.unassignedOrders.filter {
            $0.status == status &&
            (
                searchText.isEmpty ||
                $0.customer.name.lowercased().contains(searchText.lowercased()) ||
                $0.orderNumber.lowercased().contains(searchText.lowercased())
            )
        }
    }
}


#Preview {
    EmployeeAllOrders(viewModel: EmployeeHomeView.ViewModel(currentUser: UserData(name: "Test user")))
}
