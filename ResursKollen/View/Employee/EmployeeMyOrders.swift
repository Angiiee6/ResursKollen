//
//  EmployeeMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

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
                    Text("Hej, \(user.name ) 👋")
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

