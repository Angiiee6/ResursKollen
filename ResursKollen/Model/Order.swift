//
//  Order.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation
import SwiftUI

struct Order: Codable, Identifiable, Equatable {
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
    var assignedUser: UserData?

    /// - Returns sum of the price of all listed materials on the order.
    var totalMaterialCost: Double {
        var sum: Double = 0
        for material in materialConsumption {
            sum += material.totalPrice
        }
        return sum
    }

    /// - Returns `timeConsumption * labor cost`
    var totalLaborCost: Double {
        timeConsumption * 539
    }

    /// - Returns the sum of all labor and material costs.
    var totalOrderCost: Double {
        totalLaborCost + totalMaterialCost
    }

    //To make Order conform to Equatable
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.workPerformed == rhs.workPerformed
            && lhs.timeConsumption == rhs.timeConsumption
            && lhs.materialConsumption == rhs.materialConsumption
            && lhs.status == rhs.status
    }
}

/// Represents the current status of a work order in the system.
/// - Note:
///   - `registered`: No work has been done on the order.
///   - `delayed`: Delayed due to issues.
///   - `started`: Actively being worked on.
///   - `done`: Finished, pending review.
///   - `completed`: Fully completed, reviewed by managers and closed.
enum OrderStatus: String, Codable, CaseIterable {

    ///No work has been done on the order.
    case registered
    ///Delayed due to issues.
    case delayed
    ///Actively being worked on.
    case started
    ///Finished, pending review.
    case done
    ///Fully completed, reviewed by managers and closed.
    case completed

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
        case .done:
            "utförd"
        case .completed:
            "avslutad"
        }
    }
}

extension OrderStatus {
    var color: Color {
        switch self {
        case .registered:
            return .blue
        // case .booked:
        //   return .blue
        case .delayed:
            return .red
        case .started:
            return .orange
        case .done:
            return .purple
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
        case .done:
            return "magnifyingglass"
        case .completed:
            return "checkmark.seal"
        }
    }
}
