//
//  FirestoreManager.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import FirebaseFirestore

class FirestoreManager {
    @Published var orders: [Order] = []

    static let shared = FirestoreManager()

    let db = Firestore.firestore()

    var orderRef: CollectionReference { db.collection("orders") }
    var usersRef: CollectionReference { db.collection("users") }

    func saveOrder(_ order: Order) async throws {
        let newDocument = orderRef.document()
        var updatedOrder = order
        updatedOrder.id = newDocument.documentID
        try orderRef.document(newDocument.documentID).setData(
            from: updatedOrder
        )
    }

    func updateOrder(_ order: Order) throws {
        try orderRef.document(order.id).setData(from: order)
    }

    //Snapshot lyssnare för order collectionen som kallas i viewmodels och använder closure i viewmodel
    func listenToOrderCollection(onUpdate: @escaping ([Order]) -> Void) {
        orderRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print(
                    "Error listening to Orders: \(error.localizedDescription)"
                )
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }

            let orders = documents.compactMap { doc in
                try? doc.data(as: Order.self)
            }

            onUpdate(orders)
        }
    }

    func listenToDelayed(onUpdate: @escaping ([Order]) -> Void) {
        orderRef.whereField("status", isEqualTo: "delayed").addSnapshotListener
        { snapShot, error in
            if let error = error {
                print("Error listening to Orders \(error.localizedDescription)")
                return
            }

            guard let documents = snapShot?.documents else {
                print("No documents")
                return
            }

            let orders = documents.compactMap { doc in
                try? doc.data(as: Order.self)

            }
            onUpdate(orders)
        }
    }

    func listenToDoneOrders(onUpdate: @escaping (Result<[Order], Error>) -> Void) -> ListenerRegistration {
        return orderRef.whereField("status", isEqualTo: OrderStatus.done.rawValue).addSnapshotListener {
            snapshot,
            error in
            if let error = error {
                onUpdate(.failure(error))
                print("Done orders listener error.")
                return
            }
            guard let documents = snapshot?.documents else {
                onUpdate(.success([]))
                print("Done orders listener empty document.")
                return
            }
            for document in documents {
                print(document)
            }
            let orders = documents.compactMap { document in
                
                try? document.data(as: Order.self)
            }
            onUpdate(.success(orders))
            print("Done orders listener success: \(orders)")
        }
    }

    func fetchUserData(userId: String) async throws -> UserData {
        try await usersRef.document(userId).getDocument(as: UserData.self)
    }
}
