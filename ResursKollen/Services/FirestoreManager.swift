//
//  FirestoreManager.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import FirebaseFirestore

class FirestoreManager {
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
}
