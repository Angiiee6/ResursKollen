//
//  MaterialSheetView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-20.
//

import SwiftUI

///Shows a list of `Material` with the option to edit them.
struct MaterialEditSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    @Binding var materials: [Material]

    //TODO: Se över text fields för att lägga till ny del. Verkar inte gå att skriva in med decimaler?

    @State var name: String = ""
    @State var price: Double = 0
    @State var quantity: Int = 1
    var body: some View {
        BaseView{
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
                    ForEach($materials) { $material in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(material.title)
                                    .padding(.bottom, 1)
                                Text("Kr/st: \(material.priceOut.formattedAsCurrency)")
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
                                materials.removeAll(where: {
                                    $0.id == $material.id
                                })
                            } label: {
                                Label("Ta bort", systemImage: "trash")
                            }
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                }.scrollContentBackground(.hidden)
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
                                Button {
                                    materials.append(material)
                                } label: {
                                    Text(material.title)
                                }
                            }
                        }
                        .padding()
                        Spacer()
                        Button("Lägg till") {
                            let newMaterial = Material(
                                title: name,
                                quantity: quantity,
                                priceOut: price
                            )
                            
                            materials.append(newMaterial)
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
                        }.background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .buttonStyle(.borderedProminent)
                            .font(.callout)
                            .disabled(name.isEmpty)
                        
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .task {
                await viewModel.fetchMaterialList()
            }
        }
    }
}

//MARK: View Model
extension MaterialEditSheet {
    @MainActor
    class ViewModel: ObservableObject {

        @Published var premadeMaterials = MaterialEditSheet
            .premadeMaterialsMockData
        
        func fetchMaterialList() async {
            do {
                try  self.premadeMaterials = await MaterialManager.shared.readMaterialList()
            } catch {
                print("Error fetching materials: \(error)")
            }
            
        }

    }
}

#Preview {
    MaterialEditSheet(
        materials: .constant([
            Material(title: "Copper Wire", quantity: 50, priceOut: 2.50),
            Material(title: "Oak Plank", quantity: 10, priceOut: 15.00),
            Material(title: "Steel Handle", quantity: 8, priceOut: 7.25),
            Material(title: "Rose Bush", quantity: 5, priceOut: 12.99),
            Material(title: "PVC Pipe", quantity: 20, priceOut: 3.75),
            Material(title: "Brass Knob", quantity: 12, priceOut: 4.50),
            Material(title: "Mulch Bag", quantity: 15, priceOut: 6.00),
            Material(title: "LED Bulb", quantity: 25, priceOut: 8.99),
            Material(title: "Ceramic Tile", quantity: 30, priceOut: 2.20),
            Material(title: "Paint Can", quantity: 3, priceOut: 25.50),
        ])
    )
}
