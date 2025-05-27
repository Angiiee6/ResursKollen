//
//  Messages.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import Foundation
import SwiftUI

struct Message: Codable, Identifiable{
    var id: UUID = UUID()
    var title: String
    var text: String
    var date = Date()
    var category: MessagesCategory = .general
}

enum MessagesCategory: CaseIterable, Codable{
    case general, personal, finance, companyEvents
    case meetings, saftey
    
    var MessagesCategorySE: String {
        switch self{
        case .general:
            return "Allmänt – Viktiga nyheter och information till alla"
        case .personal:
            return "Personal – Information om personalfrågor"
        case .finance:
            return "Ekonomi – Budget, utlägg och löneinformation"
        case .companyEvents:
            return "Företagsevent – Sociala aktiviteter, kickoff, personalfeste"
        case .meetings:
            return "Möten – Kallelser"
        case .saftey:
            return "Säkerhet – Viktiga säkerhetsinstruktioner och påminnelser"
        }
    }
    
    var color: Color {
        switch self{
        case .general:
            return    .blue
        case .personal:
            return .green
        case .finance:
            return .orange
        case .companyEvents:
            return .white
        case .meetings:
            return .blue
        case .saftey:
            return .red
        }
    }
}
