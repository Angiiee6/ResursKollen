//
//  User.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation

//För lite mer detaljerad info om anställda
struct DetailedInfo: Codable, Identifiable{
    var id: UUID = UUID()
    var employmentType: EmploymentType = .permanent
    var personNummer: String = ""
    var bankkonto: String = ""
    //var bank: String = ""
    var salary: Int = 0
    var emergencyContact: String = ""
    var extraInfo: String = ""
  
}

enum EmploymentType: String, Codable, Hashable, CaseIterable, Identifiable{
    case permanent, temporary, hierd
    case formerEmployee, trainee, unknown
    
    var id: String {self.rawValue}
    
    var employmentTypeSE: String {
        switch self {
        case .permanent:
            return "tillsvidare"
        case .temporary:
            return "tidsbegränsad"
        case .hierd:
            return "inhyrd"
        case .formerEmployee:
            return "tidigare anställd"
        case .trainee:
            return "lärling"
        case .unknown:
            return "saknas"
        }
    }
    
}


//Basic info om den anställde
struct UserData: Codable, Identifiable, Equatable {
    
    
    var id: String
    var status: EmploymentStatus
    var name: String
    var email: String
    var employmentDate: Date
    var employmentNumber: String
    var phoneNumber: String
    var detailedInfo: DetailedInfo
    //var createdDate: Date

    //create user profile
    init(id: String = UUID().uuidString,
         status: EmploymentStatus = .employee,
         name: String = "",
         email: String = "",
         employmentDate: Date = Date(),
         employmentNumber: String = "",
         phoneNumber: String = "",
         detailedInfo: DetailedInfo = DetailedInfo()){
    
        
        self.id = id
        self.status = status
        self.email = email
        self.employmentDate = employmentDate
        self.employmentNumber = employmentNumber
        self.phoneNumber = phoneNumber
        self.name = name
        self.detailedInfo = detailedInfo
        
    }
    
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        lhs.id == rhs.id
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
    case manager, employee
         //unknown

    var nameSE: String {
        switch self {
        case .manager:
            "chef"
        case .employee:
            "anställd"
//        case .unknown:
//            "okändt"
        }
    }
}
