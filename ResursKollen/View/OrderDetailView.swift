//
//  OrderDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    let order: Order
    @State var selectedStatus: OrderStatus
    @State var timeConsumption: Double
    @State var completionText: String = ""

    init(order: Order) {
        self.order = order
        self.selectedStatus = order.status
        self.timeConsumption = order.timeConsumption
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    //MARK: Creation date
                    HStack {
                        Text("Skapad: \(order.creationDate.asYYYYMMDD)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    //MARK: Status
                    HStack {
                        Text("Status:")
                        Spacer()
                        Picker(
                            "Status",
                            selection: $selectedStatus
                        ) {
                            ForEach(OrderStatus.allCases.filter{$0 != .completed }, id: \.self) { status in
                                Text(status.nameSE.capitalized)
                                    .tag(status)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    //MARK: Customer
                    HStack {
                        VStack(alignment: .leading) {
                            Text(order.customer.name)
                            Group {
                                Text(order.customer.streetName)
                                Text(order.customer.postalCode)
                                Text(order.customer.city)
                            }
                            .font(.subheadline)
                        }
                        Spacer()
                        Text(order.customer.phoneNumber)
                    }
                    //MARK: Description
                    VStack {
                        HStack {
                            Text("Beskrivning:")
                            Spacer()
                        }
                        Text(order.description)
                            .padding(8)
                            .frame(height: 150)
                            .background(.secondary.opacity(0.35))
                    }
                    VStack {
                        HStack {
                            Text("Utfört:")
                            Spacer()
                        }
                        ZStack {
                            Color.secondary.opacity(0.35)
                            TextEditor(text: $completionText)
                                .frame(height: 150)
                                .scrollContentBackground(.hidden)
                        }
                    }
                    //MARK: Time consumption
                    HStack {
                        Text("Tidsåtgång: ")
                        Spacer()
                        Text(timeConsumption.formattedAsHours)
                        Stepper(
                            value: $timeConsumption,
                            in: 0...Double.infinity,
                            step: 0.5
                        ) {
                            Text("h")
                        }
                        .frame(maxWidth: 130)
                    }
                    //MARK: Material
                   
                }
            }
            Spacer()
            //MARK: Save button
            Button("Spara") {}
                .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .navigationTitle("Arbetsorder: \(order.orderNumber)")
    }
}

#Preview {
    OrderDetailView(
        order: Order(
            id: "1",
            title: "Laga låskista",
            description:
                "Kund behöver byta låskista mot en ny med aoigngdg gidsaghsgi gidgi gidhg gidhg  gidhg ggihfgh soidghfdsghf goisdghghgofghd wpwogjfg pcogjg spdspgojg",
            orderNumber: "244-2359-12",
            timeConsumption: 3.5,
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
