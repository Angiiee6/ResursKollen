//
//  EmployeeMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct EmployeeMyOrders: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray6), Color(.systemGray5),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Text("Hej, \(viewModel.currentUser.name) 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)

                List {
                    Section(
                        header: Text("Påbörjade ordrar:").foregroundColor(
                            .orange
                        )
                    ) {
                        ForEach(viewModel.myOrders) { order in
                            NavigationLink(
                                destination: OrderDetailView(order: order)
                            ) {
                                OrderRowMyOrders(order: order)
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button {
                                            viewModel.leaveOrder(order)
                                        } label: {
                                            Label(
                                                "Lämna order",
                                                systemImage: "hand.raised.fill"
                                            )
                                        }
                                        .tint(.red)
                                    }
                            }

                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

#Preview {
    EmployeeMyOrders(
        viewModel: EmployeeHomeView.ViewModel(
            currentUser: UserData(name: "Test user")
        )
    )
}
