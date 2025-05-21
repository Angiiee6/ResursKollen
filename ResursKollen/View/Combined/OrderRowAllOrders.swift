//
//  OrderRowAllOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct OrderRowAllOrders: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "wrench.fill")
                    .foregroundColor(order.status.color)
                    .padding(8)
                    .background(order.status.color.opacity(0.2))
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text("\(order.description)")
                        .font(.headline)

                    Text(order.customer.name)
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
#Preview {
    EmployeeHomeView(
        user: UserData(id: "1", status: .employee, name: "Vivianne och Angie", employmentDate: Date(), employmentNumber: "EMP123", phoneNumber: "0701234567"),
        orders: [
            Order(id: "O1", description: "Laga Spisen",orderNumber: "123-456-AB", timeConsumption: "2h", status: .registered, dueDate: Date(), customer: Customer(name: "Kalle", phoneNumber: "0701231234", orders: [], streetName: "Storgatan 1", city: "Göteborg", postalCode: "41100", emailAddress: "kalle@mail.com")),
            Order(id: "O2",description: "Laga Spisen", orderNumber: "789-456-CD", timeConsumption: "3h", status: .started, dueDate: Date(), customer: Customer(name: "Lisa", phoneNumber: "0702345678", orders: [], streetName: "Vägen 2", city: "Stockholm", postalCode: "11300", emailAddress: "lisa@mail.com"))
        ]
    )
}
