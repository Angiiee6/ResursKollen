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
    
    let anstNr = UserData.generateEmploymentNumber()
  
    
    func createNewEmployee() async throws {
        // först ska en uth. user
        guard !user.email.isEmpty && !user.email.isEmpty else {
            print("Saknar E-post adress eller lösenord")
            return
        }
        let authData = try await AuthenticationManager.shared.addUser(
            email: user.email,
            password: password
        )
        
        
        
        let newUser = UserData(
            id: authData.user.uid,
            status: user.status,
            name: user.name,
            email: authData.user.email ?? "",
            employmentDate: user.employmentDate,
            employmentNumber: anstNr,
            phoneNumber: user.phoneNumber,
        )

        try await UsersManager.shared.createNewUser(user: newUser)
    }

}

struct AddEmployeeView: View {

    @StateObject private var viewModel = AddEmployeeViewModel()
    @State private var isManager = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kontaktuppgifter")) {
                    TextField("För- och efternamn", text: $viewModel.user.name)
                        .textContentType(.name)
                    TextField(
                        "Telefonnummer",
                        text: $viewModel.user.phoneNumber
                    )
                    .keyboardType(.phonePad)
                    TextField("E-post", text: $viewModel.user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Lösenord", text: $viewModel.password)
                }

                Section(header: Text("Anställning")) {
                    DatePicker(
                        "Anställningsdatum",
                        selection: $viewModel.user.employmentDate,
                        displayedComponents: .date
                    )
                   // Text("Anställningsnummer: test")
                    Toggle("Chef eller liknande?", isOn: $isManager)
                        .onChange(of: isManager) { _, newValue in
                            viewModel.user.status =
                                newValue ? .manager : .employee
                        }
                }

                Section {
                    HStack {
                        Button {
                            Task {
                                do {
                                    try await viewModel.createNewEmployee()
                                    dismiss()
                                } catch {
                                    print(
                                        "Fel: Kunde inte spara ny anställd – \(error)"
                                    )
                                }
                            }
                        } label: {
                            Label("Spara", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)

                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)

                        Button {
                            dismiss()
                        } label: {
                            Label("Avbryt", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Ny Anställd")
            .navigationBarTitleDisplayMode(.inline)

        }

    }
}

#Preview {
    AddEmployeeView()
}
