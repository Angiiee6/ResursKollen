//
//  OrderDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    let order: Order

    //Order
    @State var selectedStatus: OrderStatus
    @State var timeConsumption: Double
    @State var workPerformedSheetPresent: Bool = false

    //Text boxes
    @State var workPerformed: String
    @State var workPerformedExpanded: Bool = false
    @State var descriptionExpanded: Bool = false

    //Error handling
    @State var errorMessage: String = ""
    @State var errorAlertPresent: Bool = false

    init(order: Order) {
        self.order = order
        self.selectedStatus = order.status
        self.timeConsumption = order.timeConsumption
        self.workPerformed = order.workPerformed
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 32) {
                    //MARK: Creation date
                    HStack {
                        Text("Skapad: \(order.creationDate.asYYYYMMDD)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    //MARK: Status
                    HStack {
                        Text("Status:")
                        Spacer()
                        Picker(
                            "Status",
                            selection: $selectedStatus
                        ) {
                            ForEach(
                                OrderStatus.allCases.filter {
                                    $0 != .completed
                                },
                                id: \.self
                            ) { status in
                                Text(status.nameSE.capitalized)
                                    .tag(status)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    //MARK: Customer
                    HStack {
                        VStack(alignment: .leading) {
                            Text(order.customer.name)
                            Group {
                                Text(order.customer.streetName)
                                Text(order.customer.postalCode)
                                Text(order.customer.city)
                            }
                            .font(.subheadline)
                        }
                        Spacer()
                        Text(order.customer.phoneNumber)
                    }
                    //MARK: Description
                    TextBox(
                        isExpanded: $descriptionExpanded,
                        title: "Arbetsbeskrivning:",
                        text: order.description
                    )
                    VStack {
                        TextBox(
                            isExpanded: $workPerformedExpanded,
                            title: "Utfört:",
                            text: workPerformed,
                            placeHolderText:
                                "Lägg till text för att kunna spara..."
                        )
                        HStack {
                            Spacer()
                            Button("Ändra/lägg till") {
                                workPerformedSheetPresent = true
                            }
                        }
                    }
                    //MARK: Time consumption
                    HStack {
                        Text("Tidsåtgång: ")
                        Spacer()
                        Text(timeConsumption.formattedAsHours)
                        Stepper(
                            value: $timeConsumption,
                            in: 0...Double.infinity,
                            step: 0.5
                        ) {
                            Text("h")
                        }
                        .frame(maxWidth: 130)
                    }
                    //MARK: Material

                }
            }
            .scrollIndicators(.hidden)
            Spacer()
            //MARK: Save button
            Button("Spara") {
                var updatedOrder = order
                updatedOrder.status = selectedStatus
                updatedOrder.workPerformed = workPerformed
                updatedOrder.timeConsumption = timeConsumption
                do {
                    try viewModel.updateOrder(updatedOrder)
                    dismiss()
                } catch {
                    errorMessage = error.localizedDescription
                    errorAlertPresent = true
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(workPerformed.isEmpty)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .navigationTitle("Arbetsorder: \(order.orderNumber)")
        //MARK: Sheet
        .sheet(isPresented: $workPerformedSheetPresent) {
            VStack {
                Text("Utfört arbete: ")
                TextEditor(text: $workPerformed)
                Spacer()
                Button("Stäng") {
                    workPerformedSheetPresent = false
                }
            }
            .padding()
        }
        //MARK: Alert
        .alert(isPresented: $errorAlertPresent) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )

        }.onDisappear {
            errorMessage = ""
        }

    }
}

//MARK: ViewModel
extension OrderDetailView {

    class ViewModel: ObservableObject {
        let firestoreManager = FirestoreManager.shared

        func updateOrder(_ order: Order) throws {
            try firestoreManager.updateOrder(order)
        }
    }

}

//MARK: TextBox
struct TextBox: View {
    @Binding var isExpanded: Bool
    let title: String
    let text: String
    var placeHolderText: String?
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            Group {
                if isExpanded {
                    ScrollView {
                        Text(text.isEmpty ? placeHolderText ?? "" : text)

                    }
                } else {
                    Text(text.isEmpty ? placeHolderText ?? "" : text)
                }
            }
            .italic(text.isEmpty)
            .foregroundStyle(.opacity(text.isEmpty ? 0.5 : 1))
            .frame(
                maxWidth: .infinity,
                maxHeight: isExpanded ? 400 : 135,
                alignment: .leading
            )
            .padding(8)
            .background(.secondary.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .onTapGesture {
                isExpanded.toggle()
            }
        }
    }
}

//MARK: Preview
#Preview {
    OrderDetailView(
        order: Order(
            id: "1",
            title: "Laga låskista",
            description:
                "Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta Kund behöver byta  ",
            orderNumber: "244-2359-12",
            timeConsumption: 3.5,
            status: .registered,
            dueDate: Date(),
            customer: Customer(
                name: "Saga Andersson",
                phoneNumber: "070-2358914",
                orders: [],
                streetName: "Kungsgatan 61",
                city: "Uppsala",
                postalCode: "75579",
                emailAddress: "saga.andersson@gmail.com"
            )
        )
    )
}
