//
//  EditStaffView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI

struct EditStaffView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StaffViewViewModel
    @State private var isDeletingStaff: Bool = false

    //MARK: Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personuppgifter")) {
                    TextField("Namn", text: $viewModel.selectedUser.name)
                    TextField(
                        "Personnummer",
                        text: $viewModel.selectedUser.detailedInfo.personNummer
                    )
                    .keyboardType(.numberPad)
                }

                Section(header: Text("Kontaktuppgifter")) {
                    TextField("E-post", text: $viewModel.selectedUser.email)
                        .keyboardType(.emailAddress)
                    TextField(
                        "Telefonnummer",
                        text: $viewModel.selectedUser.phoneNumber
                    )
                    .keyboardType(.phonePad)
                }

                Section(header: Text("Anställning")) {
                    Text("Cheftjänst motsvarande?")
                    Picker(
                        "Chefstjänst?",
                        selection: $viewModel.selectedUser.status
                    ) {
                        Text("Ja").tag(EmploymentStatus.manager)
                        Text("Nej").tag(EmploymentStatus.employee)
                    }
                    .pickerStyle(.segmented)

                    Picker(
                        "Anställningsform",
                        selection: $viewModel.selectedUser.detailedInfo
                            .employmentType
                    ) {
                        ForEach(EmploymentType.allCases) { empltype in
                            Text(empltype.employmentTypeSE).tag(empltype)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Löneuppgifter")) {
                    TextField(
                        "Bankkonto",
                        text: $viewModel.selectedUser.detailedInfo.bankkonto
                    )
                    .keyboardType(.numberPad)
                    HStack {
                        TextField("Lön", value: $viewModel.selectedUser.detailedInfo.salary, format: .number)
                        .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Övriga uppgifter")) {
                    TextField(
                        "Närmast anhörig",
                        text: $viewModel.selectedUser.detailedInfo
                            .emergencyContact
                    )
                    TextField(
                        "Övrig information",
                        text: $viewModel.selectedUser.detailedInfo.extraInfo
                    )
                }

                Button("Radera Anställd", role: .destructive) {
                    isDeletingStaff = true

                }.alert("Radera uppgifter!", isPresented: $isDeletingStaff) {
                    Button("Ja", role: .destructive) {
                        //lite action för att radera en anställd
                    }
                    Button("Ångra", role: .cancel) {}

                } message: {
                    Text(
                        "Säker på att du vill radera \($viewModel.selectedUser.name)"
                    )
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
                        Task {
                            try await viewModel.updateStaff(
                                user: viewModel.selectedUser
                            )
                            dismiss()
                        }
                    }
                    .disabled(
                        viewModel.selectedUser.name.isEmpty
                            || viewModel.selectedUser.email.isEmpty
                    )
                }
            }
        }
    }
}
#Preview {
  /*  let testuser = UserData(
        status: .employee,
        name: "Anna Svensson",
        email: "anna@test.se",
        employmentDate: Date(timeIntervalSince1970: 1_581_292_800),
        employmentNumber: "EMP001",
        phoneNumber: "+46 8 123 456 789",
        detailedInfo: DetailedInfo(
            employmentType: .permanent,
            personNummer: "19541214-1524",
            bankkonto: "123.456.23",
            salary: 32000,
            emergencyContact: "Mamma 046-305689",
            extraInfo: "Duktig på att laga bilar"
        )
    )
*/
    NavigationStack {
        EditStaffView(viewModel: StaffViewViewModel())
    }
}
