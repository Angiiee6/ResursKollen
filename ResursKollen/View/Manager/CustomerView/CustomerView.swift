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
        
        BaseView {
            VStack {
                if viewModel.allCustomers.isEmpty {
                    Text("Inga kunder tillagda.")
                } else {
                    List {
                        ForEach(viewModel.allCustomers) { customer in
                            ZStack {
                                // Denna bakgrund kommer täcka hela bredden inklusive pilområdet
                                Color.white.opacity(0.1)
                                    .padding(.horizontal, -20) // Kompensera för listans inbyggda padding
                                
                                NavigationLink(destination: CustomerDetailView(customer: customer)) {
                                    EmptyView()
                                }
                                .padding(.horizontal)
                                
                                CustomerListItem(customer: customer)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 40)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparatorTint(Color.orange)
                        }
                    }
                    .listStyle(.plain)
                    
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
