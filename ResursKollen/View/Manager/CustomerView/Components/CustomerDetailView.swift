//
//  CustomerDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import Combine
import FirebaseFirestore
import SwiftUI
import Factory

struct CustomerDetailView: View {
    let customer: Customer

    @StateObject var viewModel : ViewModel
    @State var addOrderSheetPresent = false
    @State var searchText: String = ""

    init(customer: Customer) {
        self.customer = customer
        _viewModel = StateObject(
            wrappedValue: ViewModel(
                customerId: customer.id
            )
        )
    }

    var body: some View {
        VStack {
            CustomerInfoDisplay(customer: customer)
            Spacer()
            Divider()
            HStack {
                Text("Ordrar:")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical)
            VStack {
                if viewModel.customerOrders.isEmpty {
                    Text("Inga ordrar registrerade...")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    List {
                        ForEach(
                            filteredAndSortedOrders(
                                for: viewModel.customerOrders
                            )
                        ) {
                            order in
                            CustomerOrderListItem(order: order)
                        }
                    }
                }
            }
            //            .padding()
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
        .searchable(
            text: $searchText,
            placement: .sidebar,
            prompt: Text("Sök ordrar")
        )
    }

    private func filteredAndSortedOrders(for orders: [Order]) -> [Order] {
        orders.filter {
            searchText.isEmpty
                || $0.orderNumber.lowercased().contains(searchText.lowercased())
                || $0.title.lowercased().contains(searchText.lowercased())
                || $0.description.lowercased().contains(searchText.lowercased())
        }
        .sorted {
            if $0.status.priority == $1.status.priority {
                return $0.creationDate > $1.creationDate
            }
            return $0.status.priority < $1.status.priority
        }
    }
}

extension CustomerDetailView {

    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.managerDataProvider) var dataProvider: MainDataProvider
        let customerId: String

        @Published var customerOrders: [Order] = []

        init(customerId: String) {
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
        let dataProvider = MainDataProvider.asPreview()
        CustomerDetailView(
            customer: dataProvider.allCustomers[0]
        )
    }
}
