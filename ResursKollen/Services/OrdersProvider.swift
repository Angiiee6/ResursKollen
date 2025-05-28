//
//  OrdersProvider.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-28.
//

import SwiftUI

class AppData : ObservableObject {
    @Published var allOrders: [Order] = []
    //@Published var allUsers: [UserData] = []
    let currentUser: UserData
    
    init (currentUser: UserData){
        self.currentUser = currentUser
        FirestoreManager.shared.listenToOrderCollection { orders in
            self.allOrders = orders
        }
//        FirestoreManager.shared.listenToUserCollection { result in
//            switch result {
//            case .success(let users):
//                allUsers = users
//            case .failure(let failure):
//                print("Error collecting users collection.")
//            }
//        }
    
    }
}
