//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI

struct AllOrdersView: View {
    @StateObject private var vm = AllOrdersViewModel()
    
    var body: some View {
        VStack {
                AllOrders(orders: vm.orders)
            }
            
        }
    }


#Preview {
    AllOrdersView()
}

extension AllOrdersView{
    
    class AllOrdersViewModel: ObservableObject {
        private let firestore = FirestoreManager()
        
        @Published var orders : [Order] = []
        
        //Lyssnar direkt vi initierar viewmodel
        init() {
            listenToOrderCollection()
        }
        // Updaterar UI på maintråden
        func listenToOrderCollection() {
            firestore.listenToOrderCollection { [weak self] newOrders in
                DispatchQueue.main.async {
                    self?.orders = newOrders
                }
            }
        }
    }
}

