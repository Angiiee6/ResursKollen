//
//  EmployeeAllOrders.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-21.
//

import Combine
import SwiftUI

struct EmployeeAllOrders: View {
    @ObservedObject var dataProvider: AppDataProvider
    @State var searchText: String = ""
    @StateObject var viewModel: ViewModel

    init(dataProvider: AppDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(
            wrappedValue: ViewModel(dataProvider: dataProvider, currentUserId: dataProvider.currentUser.id)
        )
    }

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
                        ForEach(filteredOrders(for: viewModel.registeredOrders))
                        {
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
                                            self.viewModel.takeOrder(
                                                order: order
                                            )
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
                            filteredOrders(for: viewModel.startedOrders)
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
                                            self.viewModel.takeOrder(
                                                order: order
                                            )
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
                            filteredOrders(for: viewModel.delayedOrders)
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
                                            self.viewModel.takeOrder(
                                                order: order
                                            )
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
                            filteredOrders(for: viewModel.completedOrders)
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
    // tar in en status och filtrerar sökordet för att filtrera i listan
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

extension EmployeeAllOrders {

    class ViewModel: ObservableObject {

        @Published var registeredOrders: [Order] = []
        @Published var startedOrders: [Order] = []
        @Published var delayedOrders: [Order] = []
        @Published var completedOrders: [Order] = []
        let currentUserId :String

        private var cancellables = Set<AnyCancellable>()

        init(dataProvider: AppDataProvider, currentUserId: String) {
            self.currentUserId = dataProvider.currentUser.id
            dataProvider.$activeOrders
                .sink { [weak self] allOrders in
                    let unassignedOrders = allOrders.filter {
                        $0.assignedUserId == nil
                    }
                    self?.registeredOrders = unassignedOrders.filter {
                        $0.status == .registered
                    }
                    self?.startedOrders = unassignedOrders.filter {
                        $0.status == .started
                    }
                    self?.delayedOrders = unassignedOrders.filter {
                        $0.status == .delayed
                    }
                    self?.completedOrders = unassignedOrders.filter {
                        $0.status == .completed
                    }
                }
                .store(in: &cancellables)
        }

        ///Sets the order's `assignedUserId` to the current user's id.
        func takeOrder(order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUserId = currentUserId
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error taking order!")
            }
        }

        deinit {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }

    }

}

#Preview {
    NavigationStack {
        EmployeeAllOrders(dataProvider: AppDataProvider(currentUser: UserData(name: "Test user")))
    }
}
