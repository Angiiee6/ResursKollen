//
//  ReviewOrderView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import FirebaseFirestore
import SwiftUI
import Combine
import Factory

///Shows a list of orders that need review (manager only).
struct ReviewOrdersView: View {
    @StateObject var viewModel = ViewModel()
    //MARK: Body
    var body: some View {
        BaseView {
            ZStack {
                // Lägg till en bakgrund som fyller hela skärmen
                Color.clear // eller din önskade bakgrundsfärg
                    .edgesIgnoringSafeArea(.all)
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
                            }.listRowBackground(Color.white.opacity(0.1))
                                .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }.scrollContentBackground(.hidden)
                    case .noData:
                        Text("Just nu finns det inga ordrar som behöver granskas.").foregroundColor(.white)
                    case .error(let error):
                        Text("Något gick fel: ")
                        Text(error.localizedDescription)
                    }
                }
            }
        }
    }
}
//MARK: ViewModel
extension ReviewOrdersView {
    @MainActor
    class ViewModel: ObservableObject {
        @Injected(\.managerDataProvider) var dataProvider: MainDataProvider
        @Published var state: OrderDataState = .loading
        private var cancellables = Set<AnyCancellable>()

        enum OrderDataState {
            case loading
            case hasData([Order])
            case noData
            case error(Error)
        }

        init() {
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
    ReviewOrdersView()
}
