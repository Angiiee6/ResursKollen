//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI
import Combine

struct ManagerAllOrdersView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @StateObject var viewModel : ViewModel
    @State var searchText: String = ""
    @State var isCreateOrder = false
    
    init(dataProvider: MainDataProvider) {
        self.dataProvider = dataProvider
        _viewModel = StateObject(wrappedValue: ViewModel(dataProvider: dataProvider))
    }
   

    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                List {
                    Section(header: Text("Lediga ordrar").foregroundColor(.blue)) {
                        ForEach(filteredOrders(for: viewModel.registeredOrders)) { order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .manager
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                            }
                            .listRowBackground(Color.white.opacity(0.1))
                            .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }
                    }
                    Section(
                        header: Text("Tilldelade ordrar").foregroundColor(.orange)
                    ) {
                        ForEach(filteredOrders(for: viewModel.startedOrders)) { order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .manager
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                            }
                            .listRowBackground(Color.white.opacity(0.1))
                            .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }
                    }
                    Section(header: Text("Försenade ordrar").foregroundColor(.red))
                    {
                        ForEach(filteredOrders(for: viewModel.delayedOrders)) { order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .manager
                                )
                            ) {
                                OrderRowAllOrders(order: order)
                            }
                            .listRowBackground(Color.white.opacity(0.1))
                            .listRowSeparatorTint(Color.orange.opacity(0.3))
                        }
                    }
                    Section(
                        header: Text("Avslutade ordrar").foregroundColor(.green)
                    ) {
                        ForEach(filteredOrders(for: viewModel.completedOrders)) { order in
                            NavigationLink(
                                destination: OrderDetailView(
                                    order: order,
                                    status: .manager
                                )
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
                
                HStack{
                    
                    Button(action: {
                        isCreateOrder = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Skapa ny arbetsorder")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom,20)
                    }.sheet(isPresented: $isCreateOrder) {
                        CreateOrderView()
                            .presentationDragIndicator(.visible)
                    }
                    
                    
                }
                
                
                
            }.padding(.top, 1)
        }
    }

    func filteredOrders(for orders: [Order]) -> [Order] {
        orders.filter {
            searchText.isEmpty
                || $0.customer.name.lowercased().contains(
                    searchText.lowercased()
                )
                || $0.orderNumber.lowercased().contains(
                    searchText.lowercased()
                )
        }
    }
}

extension ManagerAllOrdersView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var registeredOrders: [Order] = []
        @Published var startedOrders: [Order] = []
        @Published var delayedOrders: [Order] = []
        @Published var completedOrders: [Order] = []

        private var cancellables = Set<AnyCancellable>()

        init(dataProvider: MainDataProvider) {
            dataProvider.$activeOrders
                .sink { [weak self] allOrders in
                    self?.registeredOrders = allOrders.filter {
                        $0.status == .registered
                    }
                    self?.startedOrders = allOrders.filter {
                        $0.status == .started
                    }
                    self?.delayedOrders = allOrders.filter {
                        $0.status == .delayed
                    }
                   
                }
                .store(in: &cancellables)
            dataProvider.$completedOrders.assign(to: &$completedOrders)
        }

        deinit {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
        
    }
    
}

#Preview {
    ManagerAllOrdersView(dataProvider: MainDataProvider.asPreview())
}

