//
//  CustomerView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import FirebaseFirestore
import SwiftUI

struct CustomerView: View {
    @StateObject var viewModel = ViewModel()
    @State var addCustomerSheetPresent = false
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                VStack {
                    Text("Något gick fel:")
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                }
                .font(.caption)
            case .hasData(let customers):
                if customers.isEmpty {
                    Text("Inga kunder tillagda.")
                }
                else {
                    List {
                        ForEach(customers) { customer in
                            NavigationLink {
                                CustomerDetailView(customer: customer)
                            } label: {
                                CustomerListItem(customer: customer)
                            }

                             
                        }
                    }
                }
            }
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Ny kund") {
                    addCustomerSheetPresent = true
                }
            }
        }
        .sheet(isPresented: $addCustomerSheetPresent) {
            AddCustomerSheet()
        }
    }
}

extension CustomerView {

    @MainActor
    class ViewModel: ObservableObject {

        @Published var state: CustomersDataState = .loading

        private var listener: ListenerRegistration?

        enum CustomersDataState {
            case loading
            case error(Error)
            case hasData([Customer])
        }

        init() {
            self.listener = FirestoreManager.shared.listenToCustomers {
                result in
                switch result {
                case .success(let customers):
                    self.state = .hasData(customers)
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }

        deinit {
            self.listener?.remove()
            self.listener = nil
        }

    }

}

#Preview {
    CustomerView()
}
