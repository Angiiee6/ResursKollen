//
//  Double + Extension.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import Foundation

extension Double {
    
    /// Formats a double (hours) into a String with 1 decimal, e.g. `10.5000 to "10,5"`
    var formattedAsHours: String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    
    /// Formats a double (price) into a String with 2 decimals, e.g. `1000.500 to "1000,50"`
    var formattedAsCurrency: String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self))"
    }
}
