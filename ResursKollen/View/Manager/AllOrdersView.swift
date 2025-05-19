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
        
        init() {
            listenToOrderCollection()
        }
        
        func listenToOrderCollection() {
            let orderRef = firestore.orderRef
            
            orderRef.addSnapshotListener {snapshot, error in
                if let error = error {
                    print("Error listening to Orders: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.orders = documents.compactMap { doc in
                    try? doc.data(as: Order.self)
                }
                
            }
        }
        
    }
}

