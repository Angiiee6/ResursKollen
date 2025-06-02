//
//  CustomerDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import SwiftUI

struct CustomerDetailView: View {
    let customer: Customer
    @StateObject var viewModel: ViewModel
    @State var addOrderSheetPresent = false

    init(customer: Customer) {
        self.customer = customer
        _viewModel = StateObject(
            wrappedValue: ViewModel(customerId: customer.id)
        )
    }

    var body: some View {
        VStack {
            CustomerInfoDisplay(customer: customer)
            Spacer()
            VStack {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                case .error(_):
                    VStack {
                        Text("Kunde inte ladda ordrar.")
                            .foregroundStyle(.red)
                            .italic()
                        Button("Försök igen") {
                            Task {
                                await viewModel.fetchOrdersForCustomer()
                            }
                        }
                    }
                case .hasData(let orders):
                    if orders.isEmpty {
                        Text("Inga ordrar registrerade...")
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                    else {
                        List {
                            ForEach(orders){order in
                                HStack (alignment: .top) {
                                    VStack(alignment: .leading){
                                        Text(order.title)
                                        Text(order.description)
                                            .font(.caption2)
                                            .lineLimit(3)
                                    }
                                    Spacer()
                                    Text(order.status.nameSE)
                                        .foregroundStyle(order.status.color)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            Spacer()
            Button(action: {
                addOrderSheetPresent = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Skapa ny arbetsorder")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom,20)
            }
        }
        .padding()
        .navigationTitle("Kundinformation")
        .task {
            await viewModel.fetchOrdersForCustomer()
        }
        .sheet(isPresented: $addOrderSheetPresent) {
            CreateOrderView(customer: customer)
        }
    }
}

extension CustomerDetailView {

    @MainActor
    class ViewModel: ObservableObject {
        let customerId: String
        @Published var state: CustomerOrdersDataState = .loading

        init(customerId: String) {
            self.customerId = customerId
        }

        func fetchOrdersForCustomer() async {
            state = .loading
            do {
                let orders =
                    try await FirestoreManager.shared.fetchOrdersForCustomer(
                        customerId: customerId
                    )
                state = .hasData(orders)
            } catch {
                state = .error(error)
            }
        }

        enum CustomerOrdersDataState {
            case loading
            case error(Error)
            case hasData([Order])
        }

    }

}

#Preview {
    NavigationStack {
        CustomerDetailView(
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
}
