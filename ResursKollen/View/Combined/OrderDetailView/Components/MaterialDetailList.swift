//
//  MaterialDetailList.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import SwiftUI

///Shows a list of all `Material` on an order.
struct MaterialDetailList: View {
    
   // let selectedMaterial: SelectedMaterial
    
    let materials: [Material]
    var body: some View {
       
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
                ForEach(materials) { material in
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
    }
}

#Preview {
  //  MaterialDetailList(materials: [])
}
