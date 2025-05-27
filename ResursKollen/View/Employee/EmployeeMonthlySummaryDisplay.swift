//
//  EmployeeMonthlySummaryDisplay.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-27.
//

import SwiftUI

struct EmployeeMonthlySummaryDisplay: View {
    let hoursWorkedThisMonth: Double
    var body: some View {
        HStack {
            Text("Arbetade timmar denna månad:")
            Text("\(hoursWorkedThisMonth.formattedAsHours)")
                .fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    EmployeeMonthlySummaryDisplay(hoursWorkedThisMonth: 15.5)
}
