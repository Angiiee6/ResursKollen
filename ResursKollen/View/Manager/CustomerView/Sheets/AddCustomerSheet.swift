//
//  AddCustomerSheet.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import SwiftUI

struct AddCustomerSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()

    @State var alertIsPresent = false

    @State var name: String = ""
    @State var streetName: String = ""
    @State var postalCode: String = ""
    @State var city: String = ""
    @State var phone: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            Form {
                Section("Kundinformation") {
                    TextField("Namn", text: $name)

                    TextField("Gata", text: $streetName)
                    TextField("Postkod", text: $postalCode)
                    TextField("Stad", text: $city)
                    TextField("Telefonnummer", text: $phone)
                    TextField("Emailadress", text: $email)
                }
            }
            Spacer()
            Button("Spara") {
                Task {
                    let newCustomer = Customer(
                        name: name,
                        phoneNumber: phone,
                        streetName: streetName,
                        city: city,
                        postalCode: postalCode,
                        emailAddress: email
                    )
                    await viewModel.saveCustomer(newCustomer)
                    alertIsPresent = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("Meddelande", isPresented: $alertIsPresent) {
            Button("Ok") {
                dismiss()
            }

        } message: {
            Text(viewModel.alertMessage)
        }

    }
}

extension AddCustomerSheet {

    class ViewModel: ObservableObject {

        var alertMessage: String = ""

        func saveCustomer(_ customer: Customer) async {
            do {
                try await FirestoreManager.shared.saveCustomer(customer)
                alertMessage = "Ny kund tillagd!"
            } catch {
                alertMessage =
                    "Något gick fel - kund kunde inte sparas: \(error.localizedDescription)"
            }
        }

    }

}

#Preview {
    AddCustomerSheet()
}
