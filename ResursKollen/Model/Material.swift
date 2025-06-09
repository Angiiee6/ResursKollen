//
//  Material.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation


struct Material: Codable, Identifiable, Equatable {
    var name: String
    var quantity: Int = 1
    var price: Double
    var id: String = UUID().uuidString
    
    //Da
    var priceIn: Double = 0.0
    var description: String = ""
    var unit: MaterialUnits = .st
    var categorey: MaterialCategory = .electrical
    
    /// - Returns the `price * quantity`.
    var totalPrice: Double {
        price * Double(quantity)
    }
    
    //Makes Material comform to Equatable
    static func ==(lhs: Material, rhs: Material) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.name == rhs.name &&
                   lhs.totalPrice == rhs.totalPrice
        }
}



enum MaterialUnits: String, CaseIterable, Codable{
  
    case st = "Styck"
    case M = "Meter"
    case kg = "kilo"
    case l = "liter"
    
}


enum MaterialCategory: String, Codable, CaseIterable {
        case fasteners = "Fästelement"
       case tools = "Verktyg och tillbehör"
       case protectiveGear = "Skydd & arbetskläder"
       case timber = "Trä & skivmaterial"
       case carpentry = "Snickerimaterial"
       case insulation = "Tätskikt & isolering"
       case electrical = "El & belysning"
       case plumbing = "VVS & rör"
       case consumables = "Förbrukning & städ"
       case miscellaneous = "Övrigt"
    
    var MaterialCategorySymbol: String {
        switch self{
        case .fasteners:
            return "screwdriver"
        case .protectiveGear:
            return "shield.lefthalf.fill"
        case .timber:
            return "square.split.2x2"
        case .tools:
            return "wrench.and.screwdriver"
        case .carpentry:
            return "hammer.fill"
        case .insulation:
            return "drop.triangle.fill"
        case .electrical:
            return "bolt.fill"
        case .plumbing:
            return "drop.fill"
        case .consumables:
            return "trash.fill"
        case .miscellaneous:
            return "cube.transparent"
        }
    }
    
}
