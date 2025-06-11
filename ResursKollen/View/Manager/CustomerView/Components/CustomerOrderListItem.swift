//
//  CustomerOrderListItem.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-03.
//

import SwiftUI

struct CustomerOrderListItem: View {
    let order: Order
    //MARK: Body
    var body: some View {
        HStack (alignment: .top) {
            VStack(alignment: .leading) {
                Text(order.orderNumber)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(order.title)
                    .font(.subheadline)
                Text(order.description)
                    .font(.caption2)
                    .lineLimit(3)
            }
            Spacer()
            VStack (alignment: .leading) {
                Text("Status:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(order.status.nameSE.capitalized)
                    .foregroundStyle(order.status.color)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    CustomerOrderListItem(order: MainDataProvider.withMockData().activeOrders[0])
}
