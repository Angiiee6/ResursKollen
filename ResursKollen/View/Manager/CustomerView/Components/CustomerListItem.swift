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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(customer.name)
                Text(customer.streetName)
                HStack {
                    Text(customer.postalCode)
                    Text(customer.city)
                }
                
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(customer.phoneNumber)
                Text(customer.emailAddress)
            }
        }
        .padding(8)
        
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
