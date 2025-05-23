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
                DetailRow(icon: "person.text.rectangle", label: "Personnummer", value: user.detailedInfo.personNummer)
                DetailRow(icon: "banknote", label: "Månadslön", value: String(user.detailedInfo.salary))
                DetailRow(icon: "creditcard", label: "Kontonummer", value: user.detailedInfo.bankkonto)
                
             
                DetailRow(icon: "person.2.fill", label: "Närmast anhörig", value: user.detailedInfo.emergencyContact)
                
                DetailRow(icon: "ellipsis.circle", label: "Extra info", value: user.detailedInfo.extraInfo)
                   .listRowBackground(Color.white)
            }
            
        
        }
}

#Preview {
    ShowDetailsView(user: UserData.UserDataMockData as UserData)
}
