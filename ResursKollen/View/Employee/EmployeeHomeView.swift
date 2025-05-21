//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    let user: UserData
    let orders: [Order]

    var body: some View
    {
        NavigationStack {
            TabView {
                Tab("Mina Ordrar", systemImage:
                        "list.bullet.clipboard"
                ) {
                    EmployeeMyOrders(user: user, orders: orders)
                }
                Tab("Alla Ordrar", systemImage:
                        "list.bullet.clipboard"
                ) {
                    AllOrdersView()
                }
                Tab("Personal", systemImage: "person.3") {
                        StaffView()
                }
            }
        }
    }
}

// Förhandsvisning med mockdata
#Preview {
    EmployeeHomeView(
        user: UserData(id: "1", status: .employee, name: "Vivianne och Angie", employmentDate: Date(), employmentNumber: "EMP123", phoneNumber: "0701234567"),
        orders: [
            Order(id: "O1", description: "Laga Spisen",orderNumber: "123-456-AB", timeConsumption: 2, status: .registered, dueDate: Date(), customer: Customer(name: "Kalle", phoneNumber: "0701231234", orders: [], streetName: "Storgatan 1", city: "Göteborg", postalCode: "41100", emailAddress: "kalle@mail.com")),
            Order(id: "O2",description: "Laga Spisen", orderNumber: "789-456-CD", timeConsumption: 3, status: .started, dueDate: Date(), customer: Customer(name: "Lisa", phoneNumber: "0702345678", orders: [], streetName: "Vägen 2", city: "Stockholm", postalCode: "11300", emailAddress: "lisa@mail.com"))
        ]
    )
}

