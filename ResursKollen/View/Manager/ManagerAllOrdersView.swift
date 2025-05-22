//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI

struct ManagerAllOrdersView: View {
    @StateObject private var vm = AllOrdersViewModel()
    @State var searchText : String = ""
    
    
    var body: some View {
        List {
            Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                ForEach(filteredOrders(for: .registered)) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRowAllOrders(order: order)
                    }
                }
            }
            
            Section(header: Text("Påbörjade ordrar").foregroundColor(.orange)) {
                ForEach(filteredOrders(for: .started)) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRowAllOrders(order: order)
                    }
                }
            }
            
            Section(header: Text("Försenade ordrar").foregroundColor(.red)) {
                ForEach(filteredOrders(for: .delayed)) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRowAllOrders(order: order)
                    }
                }
            }
            
            Section(header: Text("Avslutade ordrar").foregroundColor(.green)) {
                ForEach(filteredOrders(for: .completed)) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRowAllOrders(order: order)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Alla ordrar")
        .searchable(text: $searchText, prompt: "Sök bland ordrar")
        
    }
    func filteredOrders(for status : OrderStatus) -> [Order] {
        vm.orders.filter {
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
