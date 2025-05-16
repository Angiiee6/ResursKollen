//
//  User.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var status: EmploymentStatus
    var name: String
    var employmentDate: Date
    var employmentNumber: String
    var phoneNumber: String
}

enum EmploymentStatus: Codable {
    case manager, employee

    var nameSE: String {
        switch self {
        case .manager:
            "chef"
        case .employee:
            "anställd"
        }
    }
}
