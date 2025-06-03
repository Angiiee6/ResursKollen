//
//  CustomerView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import FirebaseFirestore
import SwiftUI

struct CustomerView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var viewModel: ViewModel
    @State var addCustomerSheetPresent = false

    init(dataProvider: MainDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(
            wrappedValue: ViewModel(dataProvider: dataProvider)
        )
    }

    var body: some View {
        VStack {
            if viewModel.allCustomers.isEmpty {
                Text("Inga kunder tillagda.")
            } else {
                List {
                    ForEach(viewModel.allCustomers) { customer in
                        NavigationLink {
                            CustomerDetailView(dataProvider: dataProvider, customer: customer)
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
        let dataProvider: MainDataProvider

        @Published var allCustomers: [Customer] = []

        init(dataProvider: MainDataProvider) {
            self.dataProvider = dataProvider
            dataProvider.$allCustomers.assign(to: &$allCustomers)
        }
    }
}

#Preview {
    NavigationStack {
        CustomerView(dataProvider: MainDataProvider.asPreview())
    }
}
