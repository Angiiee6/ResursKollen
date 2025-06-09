//
//  EditStaffView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI
struct EditStaffView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel : StaffViewViewModel
    let user: UserData
    @State var name: String
    @State var phone: String
    @State var email: String
    @State var status: EmploymentStatus
    @State var detailedInfo: DetailedInfo
    @State private var isDeletingStaff: Bool = false
    
    init(viewModel: StaffViewViewModel, user: UserData) {
        self.viewModel = viewModel
        self.user = user
        self.name = user.name
        self.phone = user.phoneNumber
        self.email = user.email
        self.status = user.status
        self.detailedInfo = user.detailedInfo
    }

    var body: some View {
        NavigationStack {
            Form{
                Section(header: Text("Personuppgifter")) {
                    TextField("Namn", text: $name)
                    TextField("Personnummer", text: $detailedInfo.personNummer)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Kontaktuppgifter")) {
                    TextField("E-post", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Telefonnummer", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Anställning")) {
                    Text("Cheftjänst motsvarande?")
                    Picker("Chefstjänst?", selection: $status) {
                        Text("Ja").tag(EmploymentStatus.manager)
                        Text("Nej").tag(EmploymentStatus.employee)
                    }
                    .pickerStyle(.segmented)

                    Picker("Anställningsform", selection: $detailedInfo.employmentType) {
                        ForEach(EmploymentType.allCases) { empltype in
                            Text(empltype.employmentTypeSE).tag(empltype)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Löneuppgifter")) {
                    TextField("Bankkonto", text: $detailedInfo.bankkonto)
                        .keyboardType(.numberPad)
                    HStack {
                        Text("Lön:")
                        Spacer()
                        Text("\(detailedInfo.salary) kr")
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Övriga uppgifter")) {
                    TextField("Närmast anhörig", text: $detailedInfo.emergencyContact)
                    TextField("Övrig information", text: $detailedInfo.extraInfo)
                }
                
                Button("Radera Anställd", role: .destructive){
                    isDeletingStaff = true
                    
                }.alert("Radera uppgifter!", isPresented: $isDeletingStaff) {
                    Button("Ja", role: .destructive){
                       //lite action för att radera en anställd
                    }
                    Button("Ångra", role: .cancel){}
                    
                }message: {
                    Text("Säker på att du vill radera \(name)")
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
                            var updatedUser = user
                            updatedUser.name = name
                            updatedUser.phoneNumber = phone
                            updatedUser.email = email
                            updatedUser.status = status
                            updatedUser.detailedInfo = detailedInfo
                            try await viewModel.updateStaff(user: updatedUser)
                            print("Sparar: \(updatedUser)")
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
        EditStaffView(viewModel: StaffViewViewModel(), user: testuser)
    }
}
