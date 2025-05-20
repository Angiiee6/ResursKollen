//
//  AddEmployeeView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-20.
//

import SwiftUI

class AddEmployeeViewModel: ObservableObject {

    @Published var user = UserData()
    @Published var password = ""
    
    
    func createNewEmployee()async throws{
        // först ska en uth. user
        guard !user.email.isEmpty && !user.email.isEmpty else {
            print("Saknar E-post adress eller lösenord")
            return
        }
       let authData = try await AuthenticationManager.shared.addUser(email: user.email, password: password)
        
        let newUser = UserData(auth: authData, name: user.name, employmentNumber: "123", phoneNumber: user.phoneNumber, employmentDay: user.employmentDate )
        
        try await UsersManager.shared.createNewUser(user: newUser)
    }

}

struct AddEmployeeView: View {

    @StateObject private var viewModel = AddEmployeeViewModel()
    @State private var isManager = false
    @State private var anstNr = ""
    
    var test: String = ""

    var body: some View {

        List {

            //let anstNr = viewModel.user.generateEmploymentNumber()

            Section(header: Text("Kontaktuppgifter")) {
                TextField("För och efternamn", text: $viewModel.user.name)
                TextField("telefonnummer", text: $viewModel.user.phoneNumber)
                TextField("E-post", text: $viewModel.user.email)
                TextField("Lösenord", text: $viewModel.password)
            }
            Section(header: Text("Anstälningsdatum")) {
                DatePicker(
                    "Anställningsdatum",
                    selection: $viewModel.user.employmentDate,
                    displayedComponents: .date
                )
                Text("Anställningsnummer: \(111)")
                    //.onAppear {
                    //    anstNr = viewModel.user.generateEmploymentNumber()
                   // }
               Toggle("Chef eller likande?", isOn: $isManager)
                   /* .onChange(of: isManager) { oldValue, newValue in
                        if newValue {
                            viewModel.user.status = .manager
                        } else {
                            viewModel.user.status = .employee
                        }
                    } */
            }
            HStack(spacing: 16) {

                Button(action: {
                    Task{
                        
                        
                        do{
                            
                         try await viewModel.createNewEmployee()
                        }catch {
                            print("fel kunde inte spara ny anställd")
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Spara")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.blue)

                Button(action: {
                    // Cancel action
                }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Avbryt")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.red)
            }
            .padding()
        }
    }
}

#Preview {
    AddEmployeeView()
}
