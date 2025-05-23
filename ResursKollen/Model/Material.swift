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
    
    var totalPrice: Double {
        price * Double(quantity)
    }
    
    //För att göra Material Equatable
    static func ==(lhs: Material, rhs: Material) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.name == rhs.name &&
                   lhs.totalPrice == rhs.totalPrice
        }
}
