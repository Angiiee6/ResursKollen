//
//  FirestoreManager.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import FirebaseFirestore

class FirestoreManager {
    @Published var orders : [Order] = []
    
    static let shared = FirestoreManager()
    
    let db = Firestore.firestore()

    var orderRef: CollectionReference { db.collection("orders") }
    

    func saveOrder(_ order: Order) async throws {
        let newDocument = orderRef.document()
        var updatedOrder = order
        updatedOrder.id = newDocument.documentID
        try orderRef.document(newDocument.documentID).setData(
            from: updatedOrder
        )
    }
    
    func listenToOrderCollection() {
        
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
