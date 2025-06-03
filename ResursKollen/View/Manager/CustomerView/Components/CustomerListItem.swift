//
//  CustomerListItem.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import SwiftUI

struct CustomerListItem: View {
    let customer: Customer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(customer.streetName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 8) {
                        Text(customer.postalCode)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(customer.city)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                    Text(customer.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.blue)
            }
            Text(customer.emailAddress)
                .font(.caption)
                .foregroundColor(.blue)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}

#Preview {
    CustomerListItem(
        customer: Customer(
            name: "Arne Ankasson",
            phoneNumber: "070-123456",
            streetName: "Kungsgatan 23",
            city: "Uppsala",
            postalCode: "75521",
            emailAddress: "ankanarne@gmail.com"
        )
    )
}
