//
//  EmployeeMyOrders.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import Factory
import SwiftUI

struct EmployeeMyOrders: View {
    @EnvironmentObject var loginVm: LoginViewViewmodel
    @StateObject var viewModel = ViewModel()
    @State var isLoading = true
    @State var isLoggedOut = false

    var body: some View {
        BaseView {
            VStack(alignment: .leading) {
                Text("Hej, \(loginVm.currentUser?.name ?? "Okänd") 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)

                List {
                    Section(
                        header: Text("Tilldelade").foregroundColor(
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
                            }.listRowBackground(Color.white.opacity(0.1))
                                .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }
                    }

                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)  // Make list background transparent
                .background(Color.clear)  // Clear background for the list

                //fejka lite fördröjning för att fåt meddelande listan i sync

                Group {
                    if isLoading {
                        HStack(alignment: .center) {
                            ProgressView("Laddar...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1.4
                            ) {  // <--- ändra antalet sekunder här
                                isLoading = false
                            }
                        }
                    } else {
                        MessagesShowView()
                    }
                }
                .animation(.easeInOut, value: isLoading)
                .transition(.opacity)

                NavigationLink(
                    destination: ContentView().navigationBarBackButtonHidden(
                        true
                    ),
                    isActive: $isLoggedOut
                ) {
                    EmptyView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    do {
                        try AuthenticationManager.shared.signOut()
                        loginVm.currentUser = nil
                    } catch {
                        print("Kunde inte logga ut användaren")
                    }
                } label: {
                    Image(
                        systemName: "rectangle.portrait.and.arrow.right"
                    )
                    .tint(.orange)
                }
            }
        }
    }
    // MessagesShowView()
}

#Preview {
    EmployeeMyOrders()
}

extension EmployeeMyOrders {

    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.employeeDataProvider) var dataProvider: MainDataProvider
        @Published var myOrders: [Order] = []

        init() {
            dataProvider.$activeOrders.map { orders in
                orders.filter {
                    $0.assignedUserId == self.dataProvider.currentUser.id
                        && $0.status != .completed
                        && $0.status != .done
                }
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
