//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI

struct ManagerAllOrdersView: View {
    @StateObject private var vm = AllOrdersViewModel()
  

    var body: some View {
            List {
                Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                    ForEach(vm.orders.filter { $0.status == .registered }) {
                        order in
                        NavigationLink(
                            destination: OrderDetailView(order: order)
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                Section(
                    header: Text("Påbörjade ordrar").foregroundColor(.orange)
                ) {
                    ForEach(vm.orders.filter { $0.status == .started }) {
                        order in
                        NavigationLink(
                            destination: OrderDetailView(order: order)
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                Section(header: Text("Försenade ordrar").foregroundColor(.red))
                {
                    ForEach(vm.orders.filter { $0.status == .delayed }) {
                        order in
                        NavigationLink(
                            destination: OrderDetailView(order: order)
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                
                Section(
                    header: Text("Avslutade ordrar").foregroundColor(.green)
                ) {
                    ForEach(vm.orders.filter { $0.status == .completed }) {
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
            .searchable(text: .constant(""), prompt: "Sök bland ordrar")
        }
}

#Preview {
    ManagerAllOrdersView()
}

extension ManagerAllOrdersView {

    class AllOrdersViewModel: ObservableObject {
        private let firestore = FirestoreManager()

        @Published var orders: [Order] = []
        @Published var delayedOrders: [Order] = []
        //Lyssnar direkt vi initierar viewmodel
        init() {
            listenToOrderCollection()
            listenToDelayed()
        }
        // Updaterar UI på maintråden
        func listenToOrderCollection() {
            firestore.listenToOrderCollection { [weak self] newOrders in
                DispatchQueue.main.async {
                    self?.orders = newOrders
                }
            }
        }
        func listenToDelayed() {
            firestore.listenToDelayed { [weak self] newOrders in
                DispatchQueue.main.async {
                    self?.delayedOrders = newOrders
                }
            }
        }
        
        func takeOrder(order: Order, currentUser: UserData) {
            var updatedOrder = order
            updatedOrder.assignedUser = currentUser
            do{
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error: Could not take order.")
            }
            
        }
    }
}
