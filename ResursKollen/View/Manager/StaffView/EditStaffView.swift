//
//  EditStaffView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI
struct EditStaffView: View {
    @Environment(\.dismiss) var dismiss
    //TODO: This initializes a new view model, not observing an existing one?
    @ObservedObject var viewModel : StaffViewViewModel
    @Binding var user: UserData
    @State private var isDeletingStaff: Bool = false

    var body: some View {
        NavigationStack {
            Form{
                Section(header: Text("Personuppgifter")) {
                    TextField("Namn", text: $user.name)
                    TextField("Personnummer", text: $user.detailedInfo.personNummer)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Kontaktuppgifter")) {
                    TextField("E-post", text: $user.email)
                        .keyboardType(.emailAddress)
                    TextField("Telefonnummer", text: $user.phoneNumber)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Anställning")) {
                    Text("Cheftjänst motsvarande?")
                    Picker("Chefstjänst?", selection: $user.status) {
                        Text("Ja").tag(EmploymentStatus.manager)
                        Text("Nej").tag(EmploymentStatus.employee)
                    }
                    .pickerStyle(.segmented)

                    Picker("Anställningsform", selection: $user.detailedInfo.employmentType) {
                        ForEach(EmploymentType.allCases) { empltype in
                            Text(empltype.employmentTypeSE).tag(empltype)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Löneuppgifter")) {
                    TextField("Bankkonto", text: $user.detailedInfo.bankkonto)
                        .keyboardType(.numberPad)
                    HStack {
                        Text("Lön:")
                        Spacer()
                        Text("\(user.detailedInfo.salary) kr")
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Övriga uppgifter")) {
                    TextField("Närmast anhörig", text: $user.detailedInfo.emergencyContact)
                    TextField("Övrig information", text: $user.detailedInfo.extraInfo)
                }
                
                Button("Radera Anställd", role: .destructive){
                    isDeletingStaff = true
                    
                }.alert("Radera uppgifter!", isPresented: $isDeletingStaff) {
                    Button("Ja", role: .destructive){
                       //lite action för att radera en anställd
                    }
                    Button("Ångra", role: .cancel){}
                    
                }message: {
                    Text("Säker på att du vill radera \(user.name)")
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
                            try await viewModel.updateStaff(user: user)
                            print("Sparar...")
                            dismiss()
                        }
                    }
                    .disabled(user.name.isEmpty || user.email.isEmpty)
                }
            }
        }
    }
}
#Preview {
    let testuser = UserData(
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

    NavigationStack {
        EditStaffView(viewModel: StaffViewViewModel(), user: .constant(testuser))
    }
}
