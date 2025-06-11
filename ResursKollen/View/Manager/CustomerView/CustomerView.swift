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

    // Sortera kunder efter namn
    private var sortedCustomers: [Customer] {
        viewModel.allCustomers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        BaseView {
            VStack(alignment: .leading, spacing: 16) {
                List {
                    // En enda sektion för alla kunder
                    Section {
                        ForEach(sortedCustomers) { customer in
                            NavigationLink {
                                CustomerDetailView(customer: customer)
                            } label: {
                                CustomerListItem(customer: customer)
                            }
                            .listRowBackground(Color.white.opacity(0.1))
                            .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }
                    } header: {
                        Text("Alla kunder")
                            .foregroundColor(.orange)
                    }
                }
                .listStyle(.insetGrouped)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                
                // Knapp för att lägga till ny kund
                Button(action: {
                    addCustomerSheetPresent = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ny kund")
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
            .sheet(isPresented: $addCustomerSheetPresent) {
                AddCustomerSheet()
                    .presentationDragIndicator(.visible)
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
