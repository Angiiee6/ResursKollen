//
//  CustomerInfoDisplay.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import SwiftUI

struct CustomerInfoDisplay: View {
    let customer: Customer
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 12) {
                VStack (alignment: .leading) {
                    Text("Namn:")
                        .font(.caption2)
                    Text(customer.name)
                }
                VStack(alignment: .leading) {
                    Text("Adress")
                        .font(.caption2)
                    VStack(alignment: .leading) {
                        Text(customer.streetName)
                        Text(customer.postalCode)
                        Text(customer.city)
                    }
                    .font(.subheadline)
                }
                
                VStack(alignment: .leading) {
                    Text("Telefonnummer:")
                        .font(.caption2)
                    Text(customer.phoneNumber)
                }
                VStack (alignment: .leading) {
                    Text("Email:")
                        .font(.caption2)
                    Text(customer.emailAddress)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    CustomerInfoDisplay(customer: Customer(
        name: "Arne Ankasson",
        phoneNumber: "070-123456",
        streetName: "Kungsgatan 23",
        city: "Uppsala",
        postalCode: "75521",
        emailAddress: "ankanarne@gmail.com"
    ))
}
