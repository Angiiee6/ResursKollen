//
//  OrderChartData.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import Foundation

struct OrderChartData: Identifiable {
    let id = UUID()
    let status: String
    let count: Int
}
