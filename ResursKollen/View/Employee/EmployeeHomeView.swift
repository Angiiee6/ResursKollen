//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import SwiftUI

struct EmployeeHomeView: View {
    @State private var selectedTab = 0
    let user: UserData
    let orders: [Order]

    var body: some View {
        TabView(selection: $selectedTab) {
            EmployeeMyOrders(user: user, orders: orders)
                .tabItem {
                    Label("Mina ordrar", systemImage: "person.fill")
                }
                .tag(0)

            AllOrders(orders: orders)
                .tabItem {
                    Label("Alla ordrar", systemImage: "tray.full.fill")
                }
                .tag(1)
        }
        .accentColor(.orange)
    }
}

struct EmployeeMyOrders: View {
    let user: UserData
    let orders: [Order]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)

            NavigationView {
                VStack(alignment: .leading) {
                    Text("Hej, \(user.name) 👋")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.leading)


                    List {
                        Section(header: Text("Påbörjade ordrar:")      .foregroundColor(.orange)) {
                            ForEach(orders) { order in
                                OrderRowMyOrders(order: order)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
        
            }
        }
    }
}

struct OrderRowMyOrders: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(order.description)")
                        .font(.headline)

                    Text(order.customer.streetName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.orange)
            }

            Text("Förfaller: \(order.dueDate, style: .date)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

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

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
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
struct AllOrders: View {
    let orders: [Order]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Lediga ordrar")      .foregroundColor(.blue)) {
                    ForEach(orders.filter { $0.status == .registered }) { order in
                        OrderRowAllOrders(order: order)
                    }
                }
                Section(header: Text("Påbörjade ordrar")      .foregroundColor(.orange)) {
                    ForEach(orders.filter { $0.status == .started }) { order in
                        OrderRowAllOrders(order: order)
                    }
                }
                Section(header: Text("Försenade ordrar")      .foregroundColor(.red)) {
                    ForEach(orders.filter { $0.status == .delayed }) { order in
                        OrderRowAllOrders(order: order)
                    }
                }

                Section(header: Text("Avslutade ordrar")      .foregroundColor(.green)) {
                    ForEach(orders.filter { $0.status == .completed }) { order in
                        OrderRowAllOrders(order: order)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Alla ordrar")
            .searchable(text: .constant(""), prompt: "Sök bland ordrar")
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

