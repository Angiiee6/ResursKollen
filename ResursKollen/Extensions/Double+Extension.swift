//
//  Double + Extension.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import Foundation

extension Double {
    var formattedAsHours: String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
