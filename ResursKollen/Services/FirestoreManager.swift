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

    //MARK: Collection references
    var activeOrdersRef: CollectionReference { db.collection("activeOrders") }
    var completedOrdersRef: CollectionReference {
        db.collection("completedOrders")
    }
    var usersRef: CollectionReference { db.collection("users") }
    var customersRef: CollectionReference { db.collection("customers") }

    //MARK: Orders

    func saveOrder(_ order: Order) async throws {
        let newDocument = activeOrdersRef.document()
        var updatedOrder = order
        updatedOrder.id = newDocument.documentID
        try activeOrdersRef.document(newDocument.documentID).setData(
            from: updatedOrder
        )
    }

    func updateOrder(_ order: Order) throws {
        try activeOrdersRef.document(order.id).setData(from: order)
    }

    //Snapshot lyssnare för order collectionen som kallas i viewmodels och använder closure i viewmodel
    func listenToOrderCollection(onUpdate: @escaping ([Order]) -> Void)
        -> ListenerRegistration
    {
        activeOrdersRef.addSnapshotListener { snapshot, error in
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
        activeOrdersRef.whereField("status", isEqualTo: "delayed")
            .addSnapshotListener { snapShot, error in
                if let error = error {
                    print(
                        "Error listening to Orders \(error.localizedDescription)"
                    )
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

    /// Listens to any order with status `done`.
    /// - Parameter onUpdate: Contains a `Result<[Order], Error>` with succesfully fetched orders or `Error` in case of errors.
    /// - Returns: A listener registration used for closing the listener.
    func listenToDoneOrders(
        onUpdate: @escaping (Result<[Order], Error>) -> Void
    ) -> ListenerRegistration {
        activeOrdersRef.whereField(
            "status",
            isEqualTo: OrderStatus.done.rawValue
        ).addSnapshotListener {
            snapshot,
            error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                onUpdate(.success([]))
                return
            }
            let orders = documents.compactMap { document in
                try? document.data(as: Order.self)
            }
            onUpdate(.success(orders))
        }
    }

    //    func listenToDelayed(onUpdate: @escaping ([Order]) -> Void) {
    //        activeOrdersRef.whereField("status", isEqualTo: "delayed")
    //            .addSnapshotListener { snapShot, error in
    //                if let error = error {
    //                    print(
    //                        "Error listening to Orders \(error.localizedDescription)"
    //                    )
    //                    return
    //                }
    //
    //                guard let documents = snapShot?.documents else {
    //                    print("No documents")
    //                    return
    //                }
    //
    //                let orders = documents.compactMap { doc in
    //                    try? doc.data(as: Order.self)
    //
    //                }
    //                onUpdate(orders)
    //            }
    //    }

    //    /// Listens to any order with status `done`.
    //    /// - Parameter onUpdate: Contains a `Result<[Order], Error>` with succesfully fetched orders or `Error` in case of errors.
    //    /// - Returns: A listener registration used for closing the listener.
    //    func listenToDoneOrders(
    //        onUpdate: @escaping (Result<[Order], Error>) -> Void
    //    ) -> ListenerRegistration {
    //        activeOrdersRef.whereField(
    //            "status",
    //            isEqualTo: OrderStatus.done.rawValue
    //        ).addSnapshotListener {
    //            snapshot,
    //            error in
    //            if let error = error {
    //                onUpdate(.failure(error))
    //                return
    //            }
    //            guard let documents = snapshot?.documents else {
    //                onUpdate(.success([]))
    //                return
    //            }
    //            let orders = documents.compactMap { document in
    //                try? document.data(as: Order.self)
    //            }
    //            onUpdate(.success(orders))
    //        }
    //    }

    func listenToCompletedOrders(
        onUpdate: @escaping (Result<[Order], Error>) -> Void
    ) -> ListenerRegistration {
        completedOrdersRef.addSnapshotListener { snapshot, error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                onUpdate(.success([]))
                return
            }
            let orders = documents.compactMap { document in
                try? document.data(as: Order.self)
            }
            onUpdate(.success(orders))
        }
    }

    //MARK: Users

    /// Fetches a specific user's data.
    /// - Parameter userId: The id of the user to fetch.
    /// - Returns: `UserData` object.
    func fetchUserData(userId: String) async throws -> UserData {
        try await usersRef.document(userId).getDocument(as: UserData.self)
    }

    /// Fetches all users' data from Firestore.
    /// - Returns: A list of `UserData` objects.
    func fetchUserDataCollection() async throws -> [UserData] {
        try await usersRef.getDocuments().documents.compactMap { document in
            try? document.data(as: UserData.self)
        }
    }

    func moveOrderFromActiveToCompleted(order: Order) async throws {
        print("active -> completed")
        let batch = db.batch()
        batch.deleteDocument(activeOrdersRef.document(order.id))
        let data = try Firestore.Encoder().encode(order)
        batch.setData(
            data,
            forDocument: completedOrdersRef.document(order.id)
        )
        try await batch.commit()
    }

    func moveOrderFromCompletedToActive(order: Order) async throws {
        print("completed -> active")
        let batch = db.batch()
        batch.deleteDocument(completedOrdersRef.document(order.id))
        let data = try Firestore.Encoder().encode(order)
        batch.setData(
            data,
            forDocument: activeOrdersRef.document(order.id)
        )
        try await batch.commit()
    }

    //MARK: Customers

    func listenToCustomers(
        onUpdate: @escaping (Result<[Customer], Error>) -> Void
    ) -> ListenerRegistration {
        return customersRef.addSnapshotListener { snapshot, error in
            if let error = error {
                onUpdate(.failure(error))
            }
            guard let documents = snapshot?.documents else {
                onUpdate(.success([]))
                return
            }
            let customers = documents.compactMap {
                try? $0.data(as: Customer.self)
            }
            onUpdate(.success(customers))
        }
    }
    
    func saveCustomer(_ customer: Customer) async throws {
        let newDocument = customersRef.document()
        var updatedCustomer = customer
        updatedCustomer.id = newDocument.documentID
        try customersRef.document(newDocument.documentID).setData(from: updatedCustomer)
    }

    func fetchCustomer(id: String) async throws -> Customer {
        try await customersRef.document(id).getDocument(as: Customer.self)
    }

    func fetchOrdersForCustomer(customerId: String) async throws -> [Order] {
        let snapshot = try await activeOrdersRef.whereField(
            "customerId",
            isEqualTo: customerId
        ).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Order.self) }
    }

    //    func listenToUserCollection(onUpdate: (Result<[UserData], Error>) -> Void) {
    //        usersRef.addSnapshotListener { snapshot, error in
    //            if let error = error {
    //                onUpdate(.failure(error))
    //                return
    //            }
    //            guard let documents = snapshot?.documents else {
    //                onUpdate(.success([]))
    //                return
    //            }
    //            let users = documents.compactMap{ try? $0.data(as: UserData.self)}
    //            onUpdate(.success(users))
    //        }
    //    }
}
