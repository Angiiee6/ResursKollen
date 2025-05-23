//
//  ReviewOrderView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import FirebaseFirestore
import SwiftUI

struct ReviewOrdersView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .hasData(let orders):
                List {
                    ForEach(orders) { order in
                        NavigationLink(
                            destination: OrderDetailView(order: order, status: .manager)
                        ) {
                            OrderRowAllOrders(order: order)
                        }
                    }
                }
            case .noData:
                Text("Just nu finns det inga ordrar som behöver granskas.")
            case .error(let error):
                Text("Något gick fel: ")
                Text(error.localizedDescription)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateOrderView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    
}

extension ReviewOrdersView {
    @MainActor
    class ViewModel: ObservableObject {

        @Published var state: OrderDataState = .loading

        private var listenerRegistration: ListenerRegistration?

        enum OrderDataState {
            case loading
            case hasData([Order])
            case noData
            case error(Error)
        }

        init() {
            self.listenerRegistration = FirestoreManager.shared
                .listenToDoneOrders { result in
                    switch result {
                    case .success(let orders):
                        if orders.isEmpty {
                            self.state = .noData
                        } else {
                            self.state = .hasData(orders)
                        }
                    case .failure(let error):
                        self.state = .error(error)
                    }
                }
        }

        deinit {
            listenerRegistration?.remove()
        }

    }
}

#Preview {
    ReviewOrdersView()
}
