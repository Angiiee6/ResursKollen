//
//  WorkHour.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-26.
//

import Foundation

struct OrderTimeUnit : Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    var time: Double
    var date: Date
    var user: UserData
}
