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
    OrderDetailView(
        order: Order(
            id: "1",
            title: "Laga låskista",
            description:
                "Dynastin styrdes av mycket vidskepliga kungar från den mytologiska stammen Shang. Dynastin grundades efter att kung Cheng Tang störtat den föregående Xiadynastin. Dynastin präglades av många krig och oroligheter, men även av stora tekniska framsteg, inte minst inom bronsgjutning som upplevde en guldålder under Shangdynastin. Shangdynastins guldålder var under kung Wu Dings regeringstid. Wu Ding bedrev många militära kampanjer mot de omgivande stammarna såsom Tufang (土方) och Guifang (鬼方) vilket resulterade i territoriella erövringar. Efter Wu Ding följde flera kungar som prioriterade nöje före stadsaffärer, vilket gjorde att kungamakten blev alltmer isolerad och tidigare underlydande grupper blev självständiga och aggressiva. Den långlivade dynastin föll slutligen efter slaget vid Muye då huset Zhou tog makten och bildade Zhoudynastin. Shangdynastin är den äldsta kinesiska dynastin med samtida skriftliga källor",
            orderNumber: "244-2359-12",
            timeConsumption: 3.5,
            materialConsumption: [
                Material(name: "Copper Wire", quantity: 50, price: 2.50),
                Material(name: "Oak Plank", quantity: 10, price: 15.00),
                Material(name: "Steel Handle", quantity: 8, price: 7.25),
                Material(name: "Rose Bush", quantity: 5, price: 12.99),
                Material(name: "PVC Pipe", quantity: 20, price: 3.75),
                Material(name: "Brass Knob", quantity: 12, price: 4.50),
                Material(name: "Mulch Bag", quantity: 15, price: 6.00),
                Material(name: "LED Bulb", quantity: 25, price: 8.99),
                Material(name: "Ceramic Tile", quantity: 30, price: 2.20),
                Material(name: "Paint Can", quantity: 3, price: 25.50),
            ],
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
