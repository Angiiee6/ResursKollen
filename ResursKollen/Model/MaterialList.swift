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
    
}
