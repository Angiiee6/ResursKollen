//
//  EmployeeMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct EmployeeMyOrders: View {
    @ObservedObject var viewModel: EmployeeHomeView.ViewModel
    @State var monthlySummarySheetPresent: Bool = false

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
                Text("Hej, \(viewModel.currentUser.name) 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
                
                List {
                    Section(
                        header: Text("Påbörjade ordrar:").foregroundColor(.orange)
                    ) {
                        ForEach(viewModel.myOrders) { order in
                            NavigationLink(
                                destination: OrderDetailView(order: order, status: .employee)
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
    EmployeeMyOrders(
        viewModel: EmployeeHomeView.ViewModel(
            currentUser: UserData(name: "Test user")
        )
    )
}
