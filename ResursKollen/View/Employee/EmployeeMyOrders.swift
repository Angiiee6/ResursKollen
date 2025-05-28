//
//  EmployeeMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct EmployeeMyOrders: View {
    @ObservedObject var dataProvider: AppData
    @StateObject var viewModel: ViewModel

    init(dataProvider: AppData) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(
            wrappedValue: ViewModel(dataProvider: dataProvider)
        )
    }

    var body: some View {
        ZStack {
            // Gradientbakgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Hej, \(dataProvider.currentUser.name) 👋")
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
                                destination: OrderDetailView(
                                    order: order,
                                    status: .employee
                                )
                            ) {
                                OrderRowMyOrders(order: order)
                                
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button {
                                            self.viewModel.leaveOrder(order)
                                        } label: {
                                            Label(
                                                "Lämna order",
                                                systemImage: "hand.raised.fill"
                                            )
                                        }
                                        .tint(.red)
                                    }
                            }.listRowBackground(Color.white.opacity(0.2))
                        }
                    }
                    
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden) // Make list background transparent
                .background(Color.clear) // Clear background for the list
                
            MessagesShowView()
            }
        }
       // MessagesShowView()
    }
}

#Preview {
    EmployeeMyOrders(dataProvider: AppData(currentUser: UserData(name: "Test user")
       )
    )
}

extension EmployeeMyOrders {

    class ViewModel: ObservableObject {

        @Published var myOrders: [Order] = []

        init(dataProvider: AppData) {
            dataProvider.$allOrders.map { orders in
                orders.filter { $0.assignedUserId == dataProvider.currentUser.id
                    && $0.status != .completed
                    && $0.status != .done}
            }
            .assign(to: &$myOrders)
        }

        ///Sets an order's `assignedUserId` to `nil`.
        func leaveOrder(_ order: Order) {
            var updatedOrder = order
            updatedOrder.assignedUserId = nil
            do {
                try FirestoreManager.shared.updateOrder(updatedOrder)
            } catch {
                print("Error leaving order!")
            }
        }
    }
}
