//
//  OrdersProvider.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-28.
//

import FirebaseFirestore
import SwiftUI

@MainActor
class MainDataProvider: ObservableObject {
    @Published var activeOrders: [Order] = []
    @Published var completedOrders: [Order] = []
    //Not in use yet
    @Published var error: Error?
    //@Published var allUsers: [UserData] = []
    let currentUser: UserData

    private var listeners = [ListenerRegistration]()

    fileprivate init(
        currentUser: UserData,
        withActiveOrders: Bool,
        withCompletedOrders: Bool,
        withAllUsers: Bool
    ) {
        self.currentUser = currentUser
        if withActiveOrders {
            listenToActiveOrders()
        }
        if withCompletedOrders {
            listenToCompletedOrders()
        }
        if withAllUsers {
            //Not yet implemented
        }

    }
    
    private init() {
        self.currentUser = UserData(name: "Test user")
        self.activeOrders = [Order.orderMockUpData]
        self.completedOrders = [Order.orderMockUpData]
    }

    private func listenToActiveOrders() {
        listeners.append(
            FirestoreManager.shared.listenToOrderCollection { orders in
                self.activeOrders = orders
            }
        )
    }

    private func listenToCompletedOrders() {
        listeners.append(
            FirestoreManager.shared.listenToCompletedOrders {
                result in
                switch result {
                case .success(let orders):
                    self.completedOrders = orders
                case .failure(let error):
                    self.error = error
                }
            }
        )
    }
    
    static func asPreview() -> MainDataProvider {
        MainDataProvider()
    }

    deinit {
        listeners.forEach { $0.remove() }
        listeners.removeAll()

    }
}

class MainDataProviderBuilder {
    private var activeOrdersAdded = false
    private var completedOrdersAdded = false
    private var allUsersAdded = false
    let currentUser: UserData

    init(currentUser: UserData) {
        self.currentUser = currentUser
    }

    func withActiveOrders() -> MainDataProviderBuilder {
        self.activeOrdersAdded = true
        return self
    }

    func withCompletedOrders() -> MainDataProviderBuilder {
        self.completedOrdersAdded = true
        return self
    }

    func withAllUsers() -> MainDataProviderBuilder {
        self.allUsersAdded = true
        return self
    }

    @MainActor func build() -> MainDataProvider {
        MainDataProvider(
            currentUser: currentUser,
            withActiveOrders: activeOrdersAdded,
            withCompletedOrders: completedOrdersAdded,
            withAllUsers: allUsersAdded
        )
    }

}
