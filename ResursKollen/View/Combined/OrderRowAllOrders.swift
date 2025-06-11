//
//  OrderRowAllOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct OrderRowAllOrders: View {
    let order: Order

    //MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "wrench.fill")
                    .foregroundColor(order.status.color)
                    .padding(8)
                    .background(order.status.color.opacity(0.2))
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text("\(order.title)")
                        .font(.headline)

                    Text(order.customerName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

            }

            Text("Status: \(order.status.nameSE)")
                .font(.caption)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(order.status.color.opacity(0.1))
                .foregroundColor(order.status.color)
                .cornerRadius(8)

            Text("Förfaller: \(order.dueDate, style: .date)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
// Förhandsvisning med mockdata
//#Preview {
//    EmployeeHomeView(
//        currentUser: UserData(name: "Test user")
//    )
//}
