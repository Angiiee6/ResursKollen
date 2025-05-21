//
//  Order.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation
import SwiftUI

struct Order: Codable, Identifiable {
    var id: String
    var title: String = ""
    var description: String = ""
    var workPerformed: String = ""
    var creationDate = Date()
    var orderNumber: String
    var timeConsumption: Double = 0
    var materialConsumption: [Material] = []
    var status: OrderStatus
    var dueDate: Date
    var customer: Customer
    
    var totalMaterialCost: Double {
        var sum: Double = 0
        for material in materialConsumption {
            sum += material.totalPrice
        }
        return sum
    }
    
    var totalLaborCost: Double {
        timeConsumption * 539
    }

    var totalOrderCost: Double {
        totalLaborCost + totalMaterialCost
    }
}

enum OrderStatus: Codable, CaseIterable {

    case registered, delayed, started, completed

    var nameSE: String {
        switch self {
        case .registered:
            "registrerad"
        // case .booked:
        //    "ledig"
        case .delayed:
            "försenad"
        case .started:
            "påbörjad"
        case .completed:
            "avslutad"
        }
    }
}

extension OrderStatus {
    var color: Color {
        switch self {
        case .registered:
            return .gray
        // case .booked:
        //   return .blue
        case .delayed:
            return .red
        case .started:
            return .orange
        case .completed:
            return .green
        }
    }

    var icon: String {
        switch self {
        case .registered:
            return "doc"
        //case .booked:
        //  return "calendar"
        case .delayed:
            return "exclamationmark.triangle"
        case .started:
            return "hammer"
        case .completed:
            return "checkmark.seal"
        }
    }
}
