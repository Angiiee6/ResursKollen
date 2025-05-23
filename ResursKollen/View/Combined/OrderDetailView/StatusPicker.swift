//
//  StatusPicker.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-23.
//

import SwiftUI

struct StatusPicker: View {
    let status: EmploymentStatus
    @Binding var selection: OrderStatus

    var body: some View {
        HStack {
            Text("Status:")
                .font(.headline)
            Spacer()
            Picker(
                "Status",
                selection: $selection
            ) {
                ForEach(filterStatuses(), id: \.self) { status in
                    Text(status.nameSE.capitalized)
                        .tag(status)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private func filterStatuses() -> [OrderStatus] {
        switch status {
        case .manager:
            OrderStatus.allCases.filter {
                $0 != .completed
            }
        case .employee:
            OrderStatus.allCases.filter {
                $0 != .completed && $0 != .done
            }
        }
    }

}

#Preview {
    StatusPicker(status: .manager, selection: .constant(.registered))
}
