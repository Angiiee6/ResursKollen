//
//  ShowDetailsView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI

struct ShowDetailsView: View {
    
    let personalNumber: String
    let salary: Int
    let phoneNumber: String
    let bankAccount: String
    let emergencyContact: String
    let extraInfo: String
    
    var body: some View {
        
            Section(header: Text("Övrig information").foregroundColor(.white)) {
                DetailRow(icon: "person.text.rectangle", label: "Personnummer", value: personalNumber, isPhoneNumber: false)
                DetailRow(icon: "banknote", label: "Månadslön", value: String(salary), isPhoneNumber: false)
                DetailRow(icon: "creditcard", label: "Kontonummer", value: bankAccount, isPhoneNumber: false)
                
             
                DetailRow(icon: "person.2.fill", label: "Närmast anhörig", value: emergencyContact, isPhoneNumber: false)
                
                DetailRow(icon: "ellipsis.circle", label: "Extra info", value: extraInfo, isPhoneNumber: false)
                    
            }                                                       .listRowBackground(Color.white.opacity(0.1))
            .listRowSeparatorTint(Color.orange.opacity(0.3))
            
        
        }
}

//#Preview {
//    ShowDetailsView(user: UserData.UserDataMockData as UserData)
//}
