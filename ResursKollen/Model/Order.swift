//
//  Order.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation

struct Order: Codable, Identifiable {
    var id: String
    var title: String = ""
    var description: String = ""
    var creationDate = Date()
    var orderNumber: String
    var timeConsumption: String
    var materialConsumption: [Material] = []
    var status: OrderStatus
    var dueDate: Date
    var customer: Customer
}

enum OrderStatus: Codable {
    case registered, booked, delayed, started, completed
    
    var nameSE : String {
        switch self {
        case .registered:
            "registrerad"
        case .booked:
            "bokad"
        case .delayed:
            "försenad"
        case .started:
            "påbörjad"
        case .completed:
            "avslutad"
        }
    }
}
