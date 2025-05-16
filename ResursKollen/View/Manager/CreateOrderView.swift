//
//  CreateOrderView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct CreateOrderView: View {
    @StateObject var viewModel = ViewModel()
    
    //Order
    @State var title: String = ""
    @State var description: String = ""
    @State var selectedDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)
    
    //Customer
    @State var name: String = ""
    @State var phoneNumber: String = ""
    @State var streetName: String = ""
    @State var postalCode: String = ""
    @State var city: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            Form {
                Section("Arbetsorder") {
                    TextField("Titel *", text: $title)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $description)
                            .frame(height: 100)
                        if description.isEmpty {
                            Text("Beskrivning")
                                .foregroundColor(.gray.opacity(0.55))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                    }
                    DatePicker(
                        "Förfallodatum:",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                }
                //TODO: Add search existing customer function?
                Section("Kundinformation") {
                    TextField("Namn *", text: $name)
                        .keyboardType(.namePhonePad)
                    TextField("Gata *", text: $streetName)
                    TextField("Postnummer *", text: $postalCode)
                        .keyboardType(.numberPad)
                    TextField("Stad *", text: $city)
                    TextField("Telefonnummer *", text: $phoneNumber)
                        .keyboardType(.namePhonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
            }
            Button("Skapa") {
                let newCustomer = Customer(
                    name: name,
                    phoneNumber: phoneNumber,
                    orders: [],
                    streetName: streetName,
                    city: city,
                    postalCode: postalCode,
                    emailAddress: email,
                    customerNumber: UUID()
                )
                let newOrder = Order(
                    id: "",
                    title: title,
                    description: description,
                    orderNumber: UUID().uuidString,
                    timeConsumption: "",
                    status: .registered,
                    dueDate: selectedDate,
                    customer: newCustomer
                )
                Task {
                    await viewModel.saveOrder(newOrder)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                name.isEmpty || streetName.isEmpty || postalCode.isEmpty
                    || city.isEmpty
                    || phoneNumber.isEmpty || title.isEmpty
            )
        }
        .navigationTitle("Skapa ny arbetsorder")
    }
}

#Preview {
    CreateOrderView()
}

extension CreateOrderView {

    class ViewModel: ObservableObject {
        let fireStoreManager = FirestoreManager()

        func saveOrder(_ order: Order) async {
          print(order)
        }

    }

}
