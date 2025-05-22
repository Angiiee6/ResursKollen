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
    
    
    @State private var mockText = ""
    
    var body: some View {
        NavigationStack {
                    Form {
                        Section("Personuppgifter") {
                            TextField("Namn", text: $user.name)
                            TextField("E-post", text: $user.email)
                                .keyboardType(.emailAddress)
                            TextField("Telefonnummer", text: $user.phoneNumber)
                                .keyboardType(.phonePad)
                        
                        }
                        
                        Section("Övrigt"){
                          TextEditor(text: $mockText)
                              
                        }

                        
                    }
                    .navigationTitle("Redigera användare")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Avbryt") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Spara") {
                                
                            try? viewModel.updateStaff(user: user)    //TODO om den klastar fixa
                               
                                print("Sparar...")
                                dismiss()
                            }
                            .disabled(user.name.isEmpty || user.email.isEmpty)
                        }
                    }
                }
            }
}

#Preview {
    NavigationStack {
      //  EditStaffView(user: UserData.UserDataMockData.last!)
    }
    }
