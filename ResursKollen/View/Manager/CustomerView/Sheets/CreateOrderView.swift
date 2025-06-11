//
//  CreateOrderView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

///Shows a form for creating a new order.
struct CreateOrderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    let customer: Customer

    //Order
    @State var title: String = ""
    @State var description: String = ""
    @State var selectedDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)

    //MARK: Body
    var body: some View {
        BaseView {
            VStack {
                Text("Skapa ny arbetsorder")
                    .font(.title)
                //MARK: Form
                Form {
                    Section("Arbetsorder") {
                        TextField("Titel *", text: $title)
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $description)
                                .frame(height: 160)
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
                            //Block selecting days before current day
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                    }
                    Section("Kundinformation"){
                        CustomerInfoDisplay(customer: customer)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                

                //MARK: Save button
                Button("Skapa") {
                    let newOrder = Order(
                        id: "",
                        title: title,
                        description: description,
                        orderNumber: UUID().uuidString,
                        status: .registered,
                        dueDate: selectedDate,
                        customerId: customer.id,
                        customerName: customer.name,
                        customerStreetName: customer.streetName
                    )
                    Task {
                        await viewModel.saveOrder(newOrder)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(
                    title.isEmpty
                )
            }
        }
        //MARK: Navigation title
        .navigationTitle("Skapa ny arbetsorder")
        //MARK: Alert
        .alert(
            "Meddelande",
            isPresented: $viewModel.messageAlertPresent,
            actions: {
                Button("Ok", role: .cancel) {
                    if viewModel.saveSuccessful {
                        dismiss()
                    }
                }
            },
            message: { Text(viewModel.message) }
        )
    }
}

#Preview {
    CreateOrderView(customer: Customer(
        name: "Arne Ankasson",
        phoneNumber: "070-123456",
        streetName: "Kungsgatan 23",
        city: "Uppsala",
        postalCode: "75521",
        emailAddress: "ankanarne@gmail.com"
    ))
}

//MARK: View Model
extension CreateOrderView {
    class ViewModel: ObservableObject {
        let fireStoreManager = FirestoreManager()

        @Published var message: String = ""
        @Published var messageAlertPresent: Bool = false
        @Published var saveSuccessful: Bool = false

        @MainActor
        func saveOrder(_ order: Order) async {
            do {
                try await fireStoreManager.saveOrder(order)
                message = "Order skapad!"
                saveSuccessful = true
                messageAlertPresent = true
            } catch {
                message = error.localizedDescription
                saveSuccessful = false
                messageAlertPresent = true
            }
        }
    }
}
