//
//  ContentView.swift
//  ResursKollen
//
//  Created by Angelica E on 2025-05-14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OrderDetailView(
            order: Order(
                id: "1",
                orderNumber: "244-2359-12",
                timeConsumption: 1,
                status: .registered,
                dueDate: Date(),
                customer: Customer(
                    name: "Saga Andersson",
                    phoneNumber: "070-2358914",
                    orders: [],
                    streetName: "Kungsgatan 61",
                    city: "Uppsala",
                    postalCode: "75579",
                    emailAddress: "saga.andersson@gmail.com"
                )
            )
        )
    }
}

#Preview {
    ContentView()
}
