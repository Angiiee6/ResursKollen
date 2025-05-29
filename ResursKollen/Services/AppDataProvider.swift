//
//  OrdersProvider.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-28.
//

import FirebaseFirestore
import SwiftUI

class AppDataProvider: ObservableObject {
    @Published var activeOrders: [Order] = []
    @Published var completedOrders: [Order] = []
    //@Published var allUsers: [UserData] = []
    let currentUser: UserData

    private var listeners = [ListenerRegistration]()
    
    //To prevent ever starting more than one listener
    private var listeningToCompletedOrders = false

    init(currentUser: UserData) {
        self.currentUser = currentUser
        listeners.append(
            FirestoreManager.shared.listenToOrderCollection { orders in
                self.activeOrders = orders
            }
        )
    }

    func startListeningToCompletedOrders() {
        if !listeningToCompletedOrders {
            listeners.append(
                FirestoreManager.shared.listenToCompletedOrders(onUpdate: {
                    result in
                    switch result {
                    case .success(let orders):
                        self.completedOrders = orders
                    case .failure(let error):
                        print(
                            "Error starting listener to completedOrders collection on Firestore: \(error.localizedDescription)"
                        )
                    }
                })
            )
            listeningToCompletedOrders = true
        }
    }

    deinit {
        listeners.forEach { $0.remove() }
        listeners.removeAll()

    }

}
