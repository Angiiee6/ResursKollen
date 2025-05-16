//
//  Customer.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation

struct Customer: Codable {
    var name: String
    var phoneNumber: String
    var orders: [Order]
    var streetName: String
    var city: String
    var postalCode: String
    var emailAddress: String
    var customerNumber = UUID()
}
