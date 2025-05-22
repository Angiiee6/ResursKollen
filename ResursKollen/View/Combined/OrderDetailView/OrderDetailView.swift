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

    //TODO: Varning innan man trycker på back-knapp? (Använd Equatable och jämför ordern som kommer in med den som går ut)

    enum ActiveSheet: Identifiable {
        case workDone, material
        var id: Self { self }
    }

    enum ActiveAlert {
        case error(Error)
        case exit, orderDone
    }

    @State var order: Order
    
    //Används för att jämföra ev. osparade ändringar om man trycker på bakåt-knappen utan att spara
    let orderOriginal: Order

    init(order: Order) {
        self.order = order
        self.orderOriginal = order
    }

    //Sheets & alerts
    @State var activeSheet: ActiveSheet?
    @State var activeAlert: ActiveAlert?
    @State var alertPresent: Bool = false

    //Text boxes
    @State var workPerformedExpanded: Bool = false
    @State var descriptionExpanded: Bool = false

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
                            selection: $order.status
                        ) {
                            ForEach(
                                OrderStatus.allCases.filter {
                                    $0 != .completed && $0 != .needsReview
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
                    CustomerDetailCard(customer: order.customer)

                    //MARK: Texts
                    TextBox(
                        isExpanded: $descriptionExpanded,
                        title: "Arbetsbeskrivning:",
                        text: order.description
                    )
                    //MARK: Work performed
                    VStack {
                        TextBox(
                            isExpanded: $workPerformedExpanded,
                            title: "Utfört:",
                            text: order.workPerformed,
                            placeHolderText:
                                "Lägg till text för att kunna spara..."
                        )
                        HStack {
                            Spacer()
                            Button("Ändra/lägg till text") {
                                activeSheet = .workDone
                            }
                        }
                    }
                    //MARK: Time consumption
                    HStack {
                        Text("Tidsåtgång:")
                        Spacer()
                        Text(order.timeConsumption.formattedAsHours)
                        Stepper(
                            value: $order.timeConsumption,
                            in: 0...Double.infinity,
                            step: 0.5
                        ) {
                            Text("h")
                        }
                        .frame(maxWidth: 130)
                    }
                    //MARK: Material
                    VStack {
                        MaterialDetailList(materials: order.materialConsumption)
                        HStack {
                            Spacer()
                            Button("Ändra/lägg till material") {
                                activeSheet = .material
                            }
                        }
                    }
                }
                .padding(.horizontal, 34)
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            Spacer()
            //MARK: Summary
            VStack {
                Divider()
                HStack {
                    Text("Arbetstid:")
                    Spacer()
                    Text("\(order.totalLaborCost.formattedAsCurrency) kr")
                }
                .font(.caption)
                HStack {
                    Text("Material:")
                    Spacer()
                    Text("\(order.totalMaterialCost.formattedAsCurrency) kr")
                }
                .font(.caption)
                HStack {
                    Text("Summa:")
                    Spacer()
                    Text("\(order.totalOrderCost.formattedAsCurrency) kr")
                }
                Divider()
            }
            .padding(.horizontal)
            //MARK: Save button
            Button("Spara") {
                do {
                    try viewModel.updateOrder(order)
                    dismiss()
                } catch {
                    activeAlert = .error(error)
                    alertPresent = true
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .disabled(order.workPerformed.isEmpty)
        }
        .navigationBarBackButtonHidden(true)
        .padding(.vertical, 16)
        .navigationTitle("Arbetsorder: \(order.orderNumber)")
        //MARK: Toolbar
        .toolbar(content: {
            //Egen back button för att kunna visa alert
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if order != orderOriginal {
                        activeAlert = .exit
                        alertPresent = true
                    }
                    else {
                        dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            //Knapp för att utföra en order
            ToolbarItem(placement: .topBarTrailing) {
                Button("Utför") {
                    activeAlert = .orderDone
                    alertPresent = true
                }
            }
        })
        //MARK: Sheets
        .sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
            //För att fylla i text om vad man gjort på en order
            case .workDone:
                VStack {
                    Text("Utfört arbete: ")
                    TextEditor(text: $order.workPerformed)
                    Spacer()
                    Button("Klar") {
                        self.activeSheet = nil
                    }
                }
                .padding()
            case .material:
                //För att lägga till/ta bort material på en order
                MaterialSheetView(materials: $order.materialConsumption)
            }

        }
        //MARK: Alerts
        .alert(isPresented: $alertPresent) {
            switch activeAlert {
            case .error(let error):
                //Vid någon form av error
                Alert(
                    title: Text("Ett fel uppstod"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            //När användaren trycker på bakåt-knappen
            case .exit:
                Alert(
                    title: Text("Avsluta utan att spara?"),
                    primaryButton: .cancel(Text("Nej")),
                    secondaryButton: .destructive(Text("Ja")) {
                        dismiss()
                    }
                )
            //När användaren trycker på utför-knappen
            case .orderDone:
                Alert(
                    title: Text("Utför order?"),
                    primaryButton: .default(Text("Nej")),
                    secondaryButton: .destructive(Text("Ja")) {
                        do {
                            var updatedOrder = order
                            updatedOrder.status = .needsReview
                            try viewModel.updateOrder(updatedOrder)
                            dismiss()
                        } catch {
                            activeAlert = .error(error)
                        }
                    }
                )
            case nil:
                Alert(title: Text(""))
            }
        }
        .onDisappear {
            activeAlert = nil
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

//MARK: Preview
#Preview {
    OrderDetailView(order: Order.orderMockUpData)
}
