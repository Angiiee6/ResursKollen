//
//  SummaryBox.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-23.
//

import SwiftUI

///Shows the price summary on an order.
struct PriceSummaryBox: View {
    let totalLaborCost: Double
    let totalMaterialCost: Double
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text("Arbetstid:")
                Spacer()
                Text("\(totalLaborCost.formattedAsCurrency) kr")
            }
            .font(.caption)
            HStack {
                Text("Material:")
                Spacer()
                Text(
                    "\(totalMaterialCost.formattedAsCurrency) kr"
                )
            }
            .font(.caption)
            HStack {
                Text("Summa:")
                Spacer()
                Text("\((totalLaborCost + totalMaterialCost).formattedAsCurrency) kr")
            }
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PriceSummaryBox(totalLaborCost: 1239, totalMaterialCost: 238)
}
