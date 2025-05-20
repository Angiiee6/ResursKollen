//
//  MaterialSheetView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-20.
//

import SwiftUI

struct MaterialSheetView: View {
    @Binding var materialConsumption: [Material]
    var body: some View {
        VStack {
            HStack {
                Text("Namn")
                Spacer()
                Text("kr/st")
                   // .frame(width: 60, alignment: .leading)
                Text("Antal")
                  //  .frame(width: 60, alignment: .trailing)
                
            }
            .padding(.horizontal, 24)
            Divider()
            List {
                ForEach(materialConsumption) { material in
                    HStack {
                        Text(material.name)
                        Spacer()
                        Text(
                            "\(material.price.formattedAsCurrency)"
                        )
                      //  .frame(width: 60, alignment: .leading)
                        Text("\(material.quantity)")
                           // .frame(width: 60, alignment: .trailing)
                    }
                    .swipeActions (allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            print("Deleted")
                        } label: {
                            Label("Ta bort", systemImage: "trash")
                        }

                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MaterialSheetView(materialConsumption: .constant( [
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
    ]))
}
