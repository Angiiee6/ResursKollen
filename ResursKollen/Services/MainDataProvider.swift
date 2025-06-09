//
//  OrdersProvider.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-28.
//

import FirebaseFirestore
import SwiftUI
import Factory

///This class handles Firestore listeners for the main data used in the app, like order collections and users collection.
/// Initialized by using [`MainDataProviderBuilder`](MainDataProviderBuilder).
@MainActor
class MainDataProvider: ObservableObject {
    @Published var activeOrders: [Order] = []
    @Published var completedOrders: [Order] = []
    @Published var allCustomers: [Customer] = []
    //Not in use yet
    @Published var error: Error?
    //@Published var allUsers: [UserData] = []
//    let currentUser: UserData

    private var listeners = [ListenerRegistration]()

    fileprivate init(
//        currentUser: UserData,
        withActiveOrders: Bool,
        withCompletedOrders: Bool,
        withAllUsers: Bool,
        withCustomers: Bool
    ) {
//        self.currentUser = currentUser
        if withActiveOrders {
            listenToActiveOrders()
        }
        if withCompletedOrders {
            listenToCompletedOrders()
        }
        if withAllUsers {
            //Not yet implemented
        }
        if withCustomers {
            listenToAllCustomers()
        }

    }

    //For preview mock data
    private init() {
//        self.currentUser = UserData(name: "Test user")
        self.activeOrders = Order.mockOrders.filter { $0.status != .completed }
        self.completedOrders = Order.mockOrders.filter {
            $0.status == .completed
        }
        self.allCustomers = Customer.mockCustomers
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

    private func listenToAllCustomers() {
        listeners.append(
            FirestoreManager.shared.listenToCustomers { result in
                switch result {
                case .success(let customers):
                    self.allCustomers = customers
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

/// A builder class for configuring and initializing a `MainDataProvider` object.
///
/// Use this class to set up listeners for specific data sets before building
/// a `MainDataProvider`.
///
/// - Note:
///   - Call `withActiveOrders()` to set a listener for all active orders.
///   - Call `withCompletedOrders()` to set a listener for all completed orders.
///   - Call `withAllUsers()` to set a listener for all users (not yet implemented).
class MainDataProviderBuilder {
    private var activeOrdersAdded = false
    private var completedOrdersAdded = false
    private var allUsersAdded = false
    private var customersAdded = false
//    let currentUser: UserData

    /// Initializes the builder with the current user.
    ///
    /// - Parameter currentUser: The current user of the session.
//    init(currentUser: UserData) {
//        self.currentUser = currentUser
//    }

    /// Adds a listener for active orders Firestore collection.
    func withActiveOrders() -> MainDataProviderBuilder {
        self.activeOrdersAdded = true
        return self
    }

    /// Adds a listener for completed orders Firestore collection.
    func withCompletedOrders() -> MainDataProviderBuilder {
        self.completedOrdersAdded = true
        return self
    }

    /// Adds a listener for all users Firestore collection.
    /// - Warning: This feature is not yet implemented.
    func withAllUsers() -> MainDataProviderBuilder {
        self.allUsersAdded = true
        return self
    }

    ///Adds a listeners for all customers Firestore collection.
    func withAllCustomers() -> MainDataProviderBuilder {
        self.customersAdded = true
        return self
    }

    /// Builds the configured `MainDataProvider`.
    ///
    /// - Returns: A fully configured `MainDataProvider` instance.
    @MainActor func build() -> MainDataProvider {
        MainDataProvider(
//            currentUser: currentUser,
            withActiveOrders: activeOrdersAdded,
            withCompletedOrders: completedOrdersAdded,
            withAllUsers: allUsersAdded,
            withCustomers: customersAdded
        )
    }
}

extension Container {
    
    var employeeDataProvider: Factory<MainDataProvider> {
        Factory(self) { @MainActor in
            MainDataProviderBuilder()
                .withActiveOrders()
                .withCompletedOrders()
                .build()
        }
    }
    
    var managerDataProvider: Factory<MainDataProvider> {
        Factory(self) {
            @MainActor in
            MainDataProviderBuilder()
                .withActiveOrders()
                .withCompletedOrders()
                .withAllCustomers()
                .build()
        }
    }
}
