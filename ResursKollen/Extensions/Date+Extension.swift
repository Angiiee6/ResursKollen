//
//  Date + Extension.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import Foundation

extension Date {

    
    /// Formats date to year, month and day, e.g. `2025-10-21`
    var asYYYYMMDD: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    
    /// Formats date to hour and minutes (24-hour format), e.g. `13:10`.
    var asHHMM: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

}
