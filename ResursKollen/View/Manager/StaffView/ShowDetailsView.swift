//
//  ShowDetailsView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI

struct ShowDetailsView: View {
    
    var user: UserData
    
    var body: some View {
        
            Section(header: Text("Övrig information").foregroundColor(.white)) {
                DetailRow(icon: "person.text.rectangle", label: "Personnummer", value: user.detailedInfo.personNummer, isPhoneNumber: false)
                DetailRow(icon: "banknote", label: "Månadslön", value: String(user.detailedInfo.salary), isPhoneNumber: false)
                DetailRow(icon: "creditcard", label: "Kontonummer", value: user.detailedInfo.bankkonto, isPhoneNumber: false)
                
             
                DetailRow(icon: "person.2.fill", label: "Närmast anhörig", value: user.detailedInfo.emergencyContact, isPhoneNumber: false)
                
                DetailRow(icon: "ellipsis.circle", label: "Extra info", value: user.detailedInfo.extraInfo, isPhoneNumber: false)
                    
            }                                                       .listRowBackground(Color.white.opacity(0.1))
            .listRowSeparatorTint(Color.white.opacity(0.3))
            
        
        }
}

#Preview {
    ShowDetailsView(user: UserData.UserDataMockData as UserData)
}
