//
//  SummaryBox.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-23.
//

import SwiftUI

///Shows the price summary on an order.
struct SummaryBox: View {
    let order: Order
    var body: some View {
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
                Text(
                    "\(order.totalMaterialCost.formattedAsCurrency) kr"
                )
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
    }
}

#Preview {
    SummaryBox(order: Order.orderMockUpData)
}
