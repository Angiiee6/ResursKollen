//
//  CustomerView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import FirebaseFirestore
import SwiftUI
import Factory

struct CustomerView: View {
    @StateObject var viewModel = ViewModel()
    @State var addCustomerSheetPresent = false

    var body: some View {
        VStack {
            if viewModel.allCustomers.isEmpty {
                Text("Inga kunder tillagda.")
            } else {
                List {
                    ForEach(viewModel.allCustomers) { customer in
                        NavigationLink {
                            CustomerDetailView(customer: customer)
                        } label: {
                            CustomerListItem(customer: customer)
                                .listItemTint(.clear)
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
        @Injected(\.managerDataProvider) var dataProvider: MainDataProvider
        @Published var allCustomers: [Customer] = []

        init() {
            dataProvider.$allCustomers.assign(to: &$allCustomers)
        }
    }
}

#Preview {
    NavigationStack {
        CustomerView()
    }
}
