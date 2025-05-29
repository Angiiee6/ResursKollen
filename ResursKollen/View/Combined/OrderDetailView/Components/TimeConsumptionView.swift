//
//  OrderTimeConsumptionView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-29.
//

import SwiftUI

struct TimeConsumptionView: View {
    @Binding var newTimeUnit: OrderTimeUnit
    @Binding var order: Order
    @Binding var activeSheet: OrderDetailView.ActiveSheet?
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Total tid på order:")
                    .font(.headline)
                Spacer()
                Text(
                    "\((newTimeUnit.time + order.totalTimeWorked).formattedAsHours) h"
                )
                .font(.headline)
            }
            if order.assignedUserId == nil {
                Text(
                    "Lägg till utförare för att kunna lägga till tid."
                )
                .font(.callout)
                .foregroundStyle(.secondary)
                .italic()
            } else {
                VStack(spacing: 24) {
                    HStack {
                        Text("Lägg till tid:")
                        Spacer()
                        Text(newTimeUnit.time.formattedAsHours)
                        Stepper(
                            value: $newTimeUnit.time,
                            in: 0...Double.infinity,
                            step: 0.5
                        ) {
                            Text("h")
                        }
                        .frame(maxWidth: 130)
                    }
                }

            }
            HStack {
                Spacer()
                Button("Detaljer") {
                    activeSheet = .timeUnits
                }
            }
        }
    }
}

#Preview {
    TimeConsumptionView(newTimeUnit: .constant(OrderTimeUnit(time: 5, date: Date(), userId: "")), order: .constant(Order.orderMockUpData), activeSheet: .constant(nil))
}
