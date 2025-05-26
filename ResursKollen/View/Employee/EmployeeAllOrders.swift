//
//  EmployeeAllOrders.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-21.
//

import SwiftUI

struct EmployeeAllOrders: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel
    @State var searchText: String = ""

    var body: some View {
        ZStack {
            // Gradientbakgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 16) {
                List {
                    Section(
                        header: Text("Lediga ordrar").foregroundColor(.blue)
                    ) {
                        ForEach(
                            filteredOrders(for: .registered).filter {
                                $0.status == .registered
                            }
                        ) {
                            order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .employee
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                                    .listRowBackground(Color.white)
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
                            }.listRowBackground(Color.white.opacity(0.2))
                        }
                    }
                    Section(
                        header: Text("Påbörjade ordrar").foregroundColor(
                            .orange
                        )
                    ) {
                        ForEach(
                            viewModel.unassignedOrders.filter {
                                $0.status == .started
                            }
                        ) {
                            order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .employee
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                                    .listRowBackground(Color.white)
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
                            }.listRowBackground(Color.white.opacity(0.2))
                        }
                    }
                    Section(
                        header: Text("Försenade ordrar").foregroundColor(.red)
                    ) {
                        ForEach(
                            viewModel.unassignedOrders.filter {
                                $0.status == .delayed
                            }
                        ) {
                            order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .employee
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                                    .listRowBackground(Color.white)
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
                            }.listRowBackground(Color.white.opacity(0.2))
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
                                destination: OrderDetailView(order: order, status: .employee)
                            ) {
                                OrderRowAllOrders(order: order)
                                    .listRowBackground(Color.white)
                            }.listRowBackground(Color.white.opacity(0.2))
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .searchable(text: $searchText, prompt: "Sök bland ordrar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    //
    // tar in en status och filtrerar baserat på status sen använder vi sökordet för att filtrera i listan
    func filteredOrders(for status: OrderStatus) -> [Order] {
        viewModel.unassignedOrders.filter {
            $0.status == status
                && (searchText.isEmpty
                    || $0.customer.name.lowercased().contains(
                        searchText.lowercased()
                    )
                    || $0.orderNumber.lowercased().contains(
                        searchText.lowercased()
                    ))
        }
    }
}

#Preview {
    NavigationStack {
        EmployeeAllOrders(
            viewModel: EmployeeHomeView.ViewModel(
                currentUser: UserData(name: "Test user")
            )
        )
    }
}
