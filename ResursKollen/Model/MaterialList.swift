//
//  MaterialList.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import Foundation

struct MaterialList: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var priceIn: Double
    var priceOut: Double
    var unit: MaterialUnits
    var category: MaterialCategory
    
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
