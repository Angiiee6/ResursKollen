//
//  CompletedOrders.swift
//  ResursKollen
//
//  Created by Vivianne Sonnerborg on 2025-06-04.
//

import SwiftUI
import Combine

struct CompletedOrders: View {
    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var completedOrdersVm: ViewModel
    @State var searchText: String = ""
    
    init(dataProvider: MainDataProvider) {
        self.dataProvider = dataProvider
        _completedOrdersVm = StateObject(wrappedValue: ViewModel(dataProvider: dataProvider))
    }

    var body: some View {
        NavigationStack {
            BaseView {
                VStack(spacing: 16) {
                    List {
                        Section(header: Text("Avslutade ordrar").foregroundColor(.green)) {
                            ForEach(filteredOrders(for: completedOrdersVm.completedOrders)) { order in
                                NavigationLink(
                                    destination: OrderDetailView(order: order, status: .manager)
                                ) {
                                    OrderRowAllOrders(order: order)
                                }
                                .listRowBackground(Color.white.opacity(0.1))
                                .listRowSeparatorTint(Color.orange.opacity(0.3))
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .searchable(text: $searchText, prompt: "Sök bland ordrar")
                }
                .padding(.top, 1)
            }
        }
    }
    

    func filteredOrders(for orders: [Order]) -> [Order] {
        orders.filter {
            searchText.isEmpty
                || $0.customerName.lowercased().contains(searchText.lowercased())
                || $0.orderNumber.lowercased().contains(searchText.lowercased())
        }
    }
}

extension CompletedOrders {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var completedOrders: [Order] = []

        private var cancellables = Set<AnyCancellable>()

        init(dataProvider: MainDataProvider) {
            dataProvider.$completedOrders
                .assign(to: &$completedOrders)
        }

        deinit {
            cancellables.forEach { $0.cancel() }
        }
    }
}

#Preview {
    CompletedOrders(dataProvider: MainDataProvider.asPreview())
}
