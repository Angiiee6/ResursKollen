//
//  CustomerDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import Combine
import FirebaseFirestore
import SwiftUI

struct CustomerDetailView: View {
    let customer: Customer

    @StateObject var viewModel: ViewModel
    @State var addOrderSheetPresent = false

    init(dataProvider: MainDataProvider, customer: Customer) {
        self.customer = customer
        _viewModel = StateObject(
            wrappedValue: ViewModel(
                dataProvider: dataProvider,
                customerId: customer.id
            )
        )
    }

    var body: some View {
        VStack {
            CustomerInfoDisplay(customer: customer)
            Spacer()
            VStack {
                if viewModel.customerOrders.isEmpty {
                    Text("Inga ordrar registrerade...")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    List {
                        ForEach(viewModel.customerOrders) { order in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
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
                .padding(.bottom, 20)
            }
        }
        .padding()
        .navigationTitle("Kundinformation")
        .sheet(isPresented: $addOrderSheetPresent) {
            CreateOrderView(customer: customer)
        }
    }
}

extension CustomerDetailView {

    @MainActor
    class ViewModel: ObservableObject {
        let customerId: String
        let dataProvider: MainDataProvider

        @Published var customerOrders: [Order] = []

        init(dataProvider: MainDataProvider, customerId: String) {
            self.dataProvider = dataProvider
            self.customerId = customerId
            let combinedPublisher = Publishers.CombineLatest(
                dataProvider.$activeOrders,
                dataProvider.$completedOrders
            )
            let customerOrdersPublisher = combinedPublisher.map {
                active,
                completed in
                let allOrders = active + completed

                let filteredOrders = allOrders.filter {
                    $0.customerId == self.customerId
                }
                return filteredOrders
            }
            customerOrdersPublisher.assign(to: &$customerOrders)
        }
    }
}

#Preview {
    NavigationStack {
        CustomerDetailView(
            dataProvider: MainDataProvider.asPreview(),
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
