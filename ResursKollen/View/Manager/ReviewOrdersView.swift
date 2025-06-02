//
//  ReviewOrderView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import FirebaseFirestore
import SwiftUI
import Combine

///Shows a list of orders that need review (manager only).
struct ReviewOrdersView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var viewModel : ViewModel
    
    init(dataProvider: MainDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(wrappedValue: ViewModel(dataProvider: dataProvider))
    }
    
    
    var body: some View {
        BaseView {
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
                    }.scrollContentBackground(.hidden)
                case .noData:
                    Text("Just nu finns det inga ordrar som behöver granskas.").foregroundColor(.white)
                case .error(let error):
                    Text("Något gick fel: ")
                    Text(error.localizedDescription)
                }
            }
            .padding()
          /* Pluset för att skapa en ny order
           .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateOrderView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            } */
        }
    }
}

extension ReviewOrdersView {
    @MainActor
    class ViewModel: ObservableObject {

        @Published var state: OrderDataState = .loading
        private var cancellables = Set<AnyCancellable>()

        enum OrderDataState {
            case loading
            case hasData([Order])
            case noData
            case error(Error)
        }

        init(dataProvider: MainDataProvider) {
            dataProvider.$activeOrders.sink{ [weak self] orders in
                let doneOrders = orders.filter{$0.status == .done}
                if doneOrders.isEmpty {
                    self?.state = .noData
                }
                else {
                    self?.state = .hasData(doneOrders)
                }
                
                }
            .store(in: &cancellables)
            }
        
        deinit{
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
        
        }
    }


#Preview {
    ReviewOrdersView(dataProvider: MainDataProvider.asPreview())
}
