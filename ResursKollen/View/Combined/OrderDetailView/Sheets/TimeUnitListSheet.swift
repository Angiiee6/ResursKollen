//
//  TimeUnitListSheet.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-26.
//

import SwiftUI

struct TimeUnitListSheet: View {
    @Environment(\.dismiss) var dismiss
    let timeUnits : [OrderTimeUnit]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Stäng") {
                    dismiss()
                }
            }
            List {
                ForEach(timeUnits) { timeUnit in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(timeUnit.date.asYYYYMMDD)
                                .font(.caption)
//                            Text(currentUserName)
//                                .font(.caption2)
                        }
                        Spacer()
                        Text("\(timeUnit.time.formattedAsHours) h")
                    }
                }
            }
        }
        .padding()
    }
}



#Preview {
    TimeUnitListSheet(timeUnits: Order.orderMockUpData.timeUnits)
}
