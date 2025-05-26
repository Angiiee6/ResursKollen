//
//  MonthlyTimeSummarySheet.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-26.
//

import SwiftUI

struct MonthlyTimeSummarySheet: View {
    let timeUnits: [OrderTimeUnit]
    var body: some View {
        VStack {
            if timeUnits.isEmpty {
                Text("Ingen tid registrerad denna månad.")
                    .italic()
            } else {
                List {
                    ForEach(timeUnits) { timeUnit in
                        HStack {
                            Text(timeUnit.date.asYYYYMMDD)
                            Spacer()
                            Text(timeUnit.time.formattedAsHours)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MonthlyTimeSummarySheet(timeUnits: Order.orderMockUpData.timeUnits)
}
