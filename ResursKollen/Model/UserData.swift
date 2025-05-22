//
//  User.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation

struct UserData: Codable, Identifiable {
    var id: String
    var status: EmploymentStatus
    var name: String
    var email: String
    var employmentDate: Date
    var employmentNumber: String
    var phoneNumber: String
    var createdDate: Date

    //create user profile
    init(id: String = UUID().uuidString,
         status: EmploymentStatus = .employee,
         name: String = "",
         email: String = "",
         employmentDate: Date = Date(),
         employmentNumber: String = "",
         createdDate: Date = Date(),
         phoneNumber: String = ""){
        
        self.id = id
        self.status = status
        self.email = email
        self.employmentDate = employmentDate
        self.employmentNumber = employmentNumber
        self.createdDate = createdDate
        self.phoneNumber = phoneNumber
        self.name = name
    }
    
 
    
    // Function to generate an uniqe emp. number  ex. ABC123
  static func generateEmploymentNumber()-> String{
     
        let letters = (0..<3).map { _ in
            Character(UnicodeScalar(Int.random(in: 65...90))!)
        }

        let digits = (0..<3).map { _ in
            String(Int.random(in: 0...9))
        }

        let result = String(letters) + digits.joined()
        
       return result
    }
    
}

enum EmploymentStatus:String, Codable, Hashable {
    case manager, employee, unknown

    var nameSE: String {
        switch self {
        case .manager:
            "chef"
        case .employee:
            "anställd"
        case .unknown:
            "okändt"
        }
    }
}
