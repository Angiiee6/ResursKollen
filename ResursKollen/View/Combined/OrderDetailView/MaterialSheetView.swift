//
//  MaterialSheetView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-20.
//

import SwiftUI

struct MaterialSheetView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    @Binding var materialConsumption: [Material]

    //TODO: Se över text fields för att lägga till ny del. Verkar inte gå att skriva in med decimaler?

    @State var name: String = ""
    @State var price: Double = 0
    @State var quantity: Int = 1
    var body: some View {
        VStack {
            //MARK: Close button
            HStack {
                Spacer()
                Button("Stäng") {
                    dismiss()
                }
            }
            Text("Förbrukat material:")
            //MARK: Material list
            List {
                ForEach($materialConsumption) { $material in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(material.name)
                                .padding(.bottom, 1)
                            Text("Kr/st: \(material.price.formattedAsCurrency)")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)

                        }
                        Spacer()
                        VStack {
                            Text("\(material.quantity)")
                            Stepper("", value: $material.quantity)
                                .font(.caption)
                                .scaleEffect(0.7)
                        }
                        .frame(width: 100)
                    }
                    //MARK: Swipe actions
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            materialConsumption.removeAll(where: {
                                $0.id == $material.id
                            })
                        } label: {
                            Label("Ta bort", systemImage: "trash")
                        }

                    }
                }
                .listRowBackground(Color.clear)
            }
            Spacer()
            Divider()
            //MARK: Add new part
            VStack {
                HStack {
                    Text("Lägg till ny del:")
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Namn:")
                        TextField("", text: $name)
                    }
                    VStack(alignment: .leading) {
                        Text("Pris:")
                        TextField(
                            "",
                            value: $price,
                            formatter: NumberFormatter()
                        )
                        .keyboardType(.decimalPad)
                    }
                    .frame(width: 80)
                    VStack(alignment: .leading) {
                        Text("Antal:")
                        TextField(
                            "",
                            value: $quantity,
                            formatter: NumberFormatter()
                        )
                        .keyboardType(.numberPad)
                    }
                    .frame(width: 50)
                }
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .font(.callout)
                HStack {
                    //MARK: Premade items list
                    Menu("Lägg till från lista") {
                        ForEach(viewModel.premadeMaterials) { material in
                            Button(action: {
                                materialConsumption.append(material)
                            }) {
                                Text(material.name)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    Button("Lägg till") {
                        let newMaterial = Material(
                            name: name,
                            quantity: quantity,
                            price: price
                        )
                        
                        materialConsumption.append(newMaterial)
                        name = ""
                        quantity = 1
                        price = 0
                        
                        //Closes keyboard
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.callout)
                    .disabled(name.isEmpty)
                }
            }
            .padding(.bottom, 16)
        }
        .padding()
    }
}

//MARK: View Model
extension MaterialSheetView {
    class ViewModel: ObservableObject {
        
        @Published var premadeMaterials = MaterialSheetView.premadeMaterialsMockData
      

    }
}

#Preview {
    MaterialSheetView(
        materialConsumption: .constant([
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
        ])
    )
}
