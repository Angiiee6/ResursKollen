//
//  TimeConsumtionDetail.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-26.
//

import SwiftUI

struct TimeConsumtionDetail: View {
    @Binding var order: Order
    @Binding var newWorkHour: WorkHour
    var body: some View {
        VStack (spacing: 24) {
            HStack {
                Text("Total tid:")
                    .font(.headline)
                Spacer()
                Text((newWorkHour.time + order.totalTimeWorked).formattedAsHours)
                    .font(.headline)
            }
            HStack {
                Text("Lägg till tid:")
                Spacer()
                Text(newWorkHour.time.formattedAsHours)
                Stepper(
                    value: $newWorkHour.time,
                    in: 0...Double.infinity,
                    step: 0.5
                ) {
                    Text("h")
                }
                .frame(maxWidth: 130)
            }
        }
    }
}

//#Preview {
//    TimeConsumtionDetail(order: .constant(Order.orderMockUpData), newHoursWorked: .constant(0))
//}
