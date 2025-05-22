//
//  EditStaffView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI

struct EditStaffView: View {
    
   
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = StaffViewViewModel()
    @Binding var user: UserData
    @State var temp = false
   
    @State private var mockText = ""
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Personuppgifter"){
                    TextField("Namn", text: $user.name)
                    TextField("Personummer", text: $user.detailedInfo.personNummer)
                }
                Section("Anställning"){
                    
                        Picker("Chefstjänst motsvarande?", selection: $user.status){
                            Text("Ja").tag(EmploymentStatus.manager)
                            Text("Nej").tag(EmploymentStatus.employee)
                        }.pickerStyle(.menu)
                    
                    Picker("Anställningsform", selection: $user.detailedInfo.employmentType){
                        
                        }
                        
                    
                }
                Section("Kontaktuppgifter"){
                    TextField("E-Post", text: $user.email)
                    TextField("Telefonnummer", text: $user.phoneNumber)
                    TextField("Närmast anhörig", text: $user.detailedInfo.emergencyContact)
                }
                
                
            }
            
            
        
            
        }
                    .navigationTitle("Redigera uppgifter")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Avbryt") {
                                dismiss()
                            
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Spara") {
                                
                                
                            try? viewModel.updateStaff(user: user)    //TODO om den kastar fixa
                               
                                print("Sparar...")
                                dismiss()
                            }
                            .disabled(user.name.isEmpty || user.email.isEmpty)
                        }
                    }
    }
}

#Preview {
    let testuser = UserData(status: .employee,
                                               name: "Anna Svensson",
                                               email: "anna@test.se",
                                               employmentDate: Date(timeIntervalSince1970: 1581292800),
                                               employmentNumber: "EMP001",
                                               phoneNumber: "+46 8 123 456 789",
                                               detailedInfo: DetailedInfo(employmentType: .permanent,
                                                              personNummer: "19541214-1524",
                                                              bankkonto: "123.456.23",
                                                              bank: "Nordea",
                                                              salary: 32000,
                                                              emergencyContact: "Mamma 046-305689",
                                                              extraInfo: "Duktig på att laga bilar"))
    
    NavigationStack {
        EditStaffView(user: .constant(testuser))
    }
    }
