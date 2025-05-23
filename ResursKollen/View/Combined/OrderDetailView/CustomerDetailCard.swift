//
//  CustomerDetailCard.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import SwiftUI

struct CustomerDetailCard: View {
    let customer: Customer
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(customer.name)
                Group {
                    Text(customer.streetName)
                    Text(customer.postalCode)
                    Text(customer.city)
                }
                .font(.subheadline)
            }
            Spacer()
            Text(customer.phoneNumber)
        }
    }
}

#Preview {
    CustomerDetailCard(customer: Customer(name: "Anna Andersson", phoneNumber: "070123456", orders: [], streetName: "Kungsgatan 27", city: "Uppsala", postalCode: "75621", emailAddress: "annaandersson@gmail.com"))
}
