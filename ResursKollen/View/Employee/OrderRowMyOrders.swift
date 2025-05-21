//
//  OrderRowMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct OrderRowMyOrders: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(order.title)")
                        .font(.headline)

                    Text(order.customer.streetName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

               
            }

            Text("Förfaller: \(order.dueDate, style: .date)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}


