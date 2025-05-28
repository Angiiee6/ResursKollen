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
    @ObservedObject var dataProvider: AppData
    @StateObject var viewModel : ViewModel
    
    init(dataProvider: AppData) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(wrappedValue: ViewModel(dataProvider: dataProvider))
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
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
                        }
                    }
                case .noData:
                    Text("Just nu finns det inga ordrar som behöver granskas.").foregroundColor(.white)
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

        init(dataProvider: AppData) {
            dataProvider.$allOrders.sink{ [weak self] orders in
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
    ReviewOrdersView(dataProvider: AppData(currentUser: UserData(name: "Test user")))
}
