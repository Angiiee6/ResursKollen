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
    
    enum ActiveSheet : Identifiable {
        case workDone, material
        var id: Self {self}
    }
    
    @State var order: Order

    @State var activeSheet: ActiveSheet?

    //Text boxes
    @State var workPerformedExpanded: Bool = false
    @State var descriptionExpanded: Bool = false

    //Error handling
    @State var errorMessage: String = ""
    @State var errorAlertPresent: Bool = false

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
                        HStack {
                            Text("Förbrukat material:")
                            Spacer()
                        }
                        VStack {
                            HStack {
                                Text("Namn")
                                Spacer()
                                Text("kr/st")
                                    .frame(width: 80, alignment: .leading)
                                Text("Antal")
                                    .frame(width: 50)
                                Text("Totalt (kr)")
                                    .frame(width: 65, alignment: .trailing)
                            }
                            .font(.caption)
                            Divider()
                            ScrollView {
                                ForEach(order.materialConsumption) { material in
                                    HStack {
                                        Text(material.name)
                                        Spacer()
                                        Text(
                                            "\(material.price.formattedAsCurrency)"
                                        )
                                        .frame(width: 80, alignment: .leading)
                                        Text("\(material.quantity)")
                                            .frame(width: 50)
                                        Text(
                                            "\(material.totalPrice.formattedAsCurrency)"
                                        )
                                        .frame(width: 65, alignment: .trailing)

                                    }
                                    .font(.caption)
                                }
                            }
                            .frame(height: 100)
                            .scrollIndicators(.never)
                        }
                        .padding()
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
                    errorMessage = error.localizedDescription
                    errorAlertPresent = true
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .disabled(order.workPerformed.isEmpty)
        }
        .padding(.vertical, 16)
        .navigationTitle("Arbetsorder: \(order.orderNumber)")
        //MARK: Sheet
        .sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
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
                MaterialSheetView(materialConsumption: $order.materialConsumption)
            }
        
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

//MARK: Preview
#Preview {
    OrderDetailView(order: Order.orderMockUpData )
}
