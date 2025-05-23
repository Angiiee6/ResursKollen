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

    @State var order: Order
    //Används för att jämföra ev. osparade ändringar om man trycker på bakåt-knappen utan att spara
    let orderOriginal: Order
    let employmentStatus: EmploymentStatus

    init(order: Order, status: EmploymentStatus) {
        self.order = order
        self.orderOriginal = order
        self.employmentStatus = status
    }

    //Sheets & alerts
    @State var activeSheet: ActiveSheet?
    @State var activeAlert: ActiveAlert?
    @State var alertPresent: Bool = false

    //Text boxes
    @State var workPerformedExpanded: Bool = false
    @State var descriptionExpanded: Bool = false

    enum ActiveSheet: Identifiable {
        case workDone, material
        var id: Self { self }
    }

    enum ActiveAlert {
        case error(Error)
        case exit, orderDone

    }

    var body: some View {
        ZStack {
            // Gradientbakgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

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
                        StatusPicker(
                            status: employmentStatus,
                            selection: $order.status
                        )

                        //MARK: Customer
                        CustomerDetailCard(customer: order.customer)
                        Divider()
                        //MARK: Description
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
                                    "Lägg till text..."
                            )
                            HStack {
                                Spacer()
                                Button("Ändra/lägg till text") {
                                    activeSheet = .workDone
                                }
                            }
                        }
                        Divider()
                        //MARK: Time consumption
                        HStack {
                            Text("Tidsåtgång:")
                                .font(.headline)
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
                            HStack {
                                Text("Förbrukat material:")
                                    .font(.headline)
                                Spacer()
                            }
                            if order.materialConsumption.isEmpty {
                                Text("Inget material tillagt.")
                                    .font(.callout)
                                    .italic()
                                    .padding()
                            } else {
                                MaterialDetailList(
                                    materials: order.materialConsumption
                                )
                            }
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
                SummaryBox(order: order)
                
                
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
            }
            .navigationBarBackButtonHidden(true)
            .padding(.vertical, 16)
            .navigationTitle("Arbetsorder: \(order.orderNumber)")
        }
        //MARK: Toolbar
        .toolbar(content: {
            //Egen back button för att kunna visa alert
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if order != orderOriginal {
                        activeAlert = .exit
                        alertPresent = true
                    } else {
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
                Button("\(employmentStatus == .manager ? "Avsluta": "Utför")") {
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
            //När användaren trycker på utför/avsluta-knappen
            case .orderDone:
                Alert(
                    title: Text(
                        "\(employmentStatus == .manager ? "Avsluta" : "Utför") order?"
                    ),
                    primaryButton: .default(Text("Nej")),
                    secondaryButton: .destructive(Text("Ja")) {
                        do {
                            var updatedOrder = order
                            updatedOrder.status =
                                switch employmentStatus {
                                case .manager:
                                    .completed
                                case .employee:
                                    .done
                                }
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
    OrderDetailView(order: Order.orderMockUpData, status: .manager)
}
