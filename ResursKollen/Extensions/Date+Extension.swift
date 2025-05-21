//
//  Date + Extension.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-19.
//

import Foundation

extension Date {

    var asYYYYMMDD: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var asHHMM: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

}
