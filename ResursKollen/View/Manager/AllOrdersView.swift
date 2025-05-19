//
//  AllOrdersView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import SwiftUI

struct AllOrdersView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
            }
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
        
        //Lyssnar direkt vi initierar viewmodlen
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

