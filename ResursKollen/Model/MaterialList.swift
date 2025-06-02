//
//  MaterialList.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import Foundation

struct MaterialList: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var price: Double
    var unit: Units
    
}

enum Units: Codable{
    case st, M, kg, l
    
    var unitsName: String {
        switch self{
        case .st:
            return "styck"
        case .kg:
            return "kilo"
        case .M:
            return "meter"
        case .l:
            return "liter"
        }
    }
}
