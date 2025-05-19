//
//  AllOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-19.
//

import SwiftUI

struct AllOrders: View {
    let orders: [Order]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Lediga ordrar")      .foregroundColor(.blue)) {
                    ForEach(orders.filter { $0.status == .registered }) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                Section(header: Text("Påbörjade ordrar")      .foregroundColor(.orange)) {
                    ForEach(orders.filter { $0.status == .started }) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                Section(header: Text("Försenade ordrar")      .foregroundColor(.red)) {
                    ForEach(orders.filter { $0.status == .delayed }) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
                
                Section(header: Text("Avslutade ordrar")      .foregroundColor(.green)) {
                    ForEach(orders.filter { $0.status == .completed }) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
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
}
