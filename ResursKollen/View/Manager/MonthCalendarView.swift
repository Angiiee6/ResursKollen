//
//  MonthCalendarView.swift
//  ResursKollen
//
//  Created by Angelica E on 2025-06-04.
//

import SwiftUI

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    var orders: [Order]
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Mån", "Tis", "Ons", "Tor", "Fre", "Lör", "Sön"]
    private let maxVisibleDots = 5
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: selectedDate).capitalized
    }
    
    private var selectedDateOrders: [Order] {
        orders.filter { calendar.isDate($0.dueDate, inSameDayAs: selectedDate) }
    }
    
    private var selectedDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: selectedDate).capitalized
    }
    
    var body: some View {
        VStack {
            //MARK: Byta månader
            // Calendar Header
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
                
                Spacer()
                
                Text(monthName)
                    .font(.headline)
                
                Spacer()
                
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                }
            }
            .padding(.bottom, 8)
            //MARK: Veckodagar
            // Weekday headers
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                }
            }
            
            // Date grid
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(daysInMonth(), id: \.self) { date in
                    let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
                    let dateOrders = orders.filter { calendar.isDate($0.dueDate, inSameDayAs: date) }
                    let uniqueStatuses = Array(Set(dateOrders.map { $0.status }))
                    
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: isCurrentMonth,
                        orderStatuses: uniqueStatuses,
                        orderCount: dateOrders.count
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.bottom)
            //MARK: Vald dag
            // Selected date orders list
            VStack(alignment: .leading) {
                Text(selectedDateFormatted)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                
                if selectedDateOrders.isEmpty {
                    Text("Inga ordrar denna dag")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(selectedDateOrders) { order in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(order.orderNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text(order.status.nameSE)
                                        .font(.caption)
                                        .padding(4)
                                        .background(order.status.color.opacity(0.2))
                                        .cornerRadius(4)
                                        .foregroundColor(order.status.color)
                                }
                                
                                Text(order.title)
                                    .font(.headline)
                                
                                Text(order.customerName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: 300)
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
        
        var dates: [Date] = []
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysToSubtract = (firstWeekday + 5) % 7
        
        //MARK: Förra månadens dagar
        // Fill in previous month
        if daysToSubtract > 0 {
            if let previousMonthDay = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstDayOfMonth) {
                for i in 0..<daysToSubtract {
                    if let date = calendar.date(byAdding: .day, value: i, to: previousMonthDay) {
                        dates.append(date)
                    }
                }
            }
        }
        
        // Add current month
        var currentDate = firstDayOfMonth
        while currentDate < monthInterval.end {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // Calculate dynamic number of weeks (5 or 6)
        //without this it will always show 6 weeks
        let totalDays = dates.count
        let weeksNeeded = (totalDays <= 35) ? 5 : 6
        let totalCells = weeksNeeded * 7
        
        //MARK: Nästa månadsdagar
        // Fill in next month (if needed)
        if totalDays < totalCells {
            if let firstOfNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) {
                for i in 0..<(totalCells - totalDays) {
                    if let date = calendar.date(byAdding: .day, value: i, to: firstOfNextMonth) {
                        dates.append(date)
                    }
                }
            }
        }
        
        return dates
    }
}

//MARK: CalendarDayView
struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let orderStatuses: [OrderStatus]
    let orderCount: Int
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    //MARK: Body
    var body: some View {
        VStack(spacing: 2) {
            Text(dayNumber)
                .font(.system(size: 14))
                .foregroundColor(isCurrentMonth ? (isSelected ? .white : .primary) : .secondary)
                .frame(width: 24, height: 24)
                .background(
                    isSelected ? Circle().fill(Color.orange) : nil
                )
            
            if orderCount > 0 {
                // Show up to 5 dots for different statuses
                HStack(spacing: 2) {
                    ForEach(orderStatuses.prefix(5), id: \.self) { status in
                        Circle()
                            .fill(status.color)
                            .frame(width: 5, height: 5)
                    }
                }
                
                // If more than 5 unique statuses, show "+X" indicator
                if orderStatuses.count > 5 {
                    Text("+\(orderStatuses.count - 5)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                // If multiple orders with same status, show count
                else if orderCount > orderStatuses.count {
                    Text("\(orderCount)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .opacity(isCurrentMonth ? 1.0 : 0.5)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedDate = Date()
        let orders = [
            Order(
                id: "1",
                title: "Order 1",
                description: "Test order",
                workPerformed: "",
                orderNumber: "123",
                status: .started,
                dueDate: Date(),
                customerId: "1",
                customerName: "Test Customer",
                customerStreetName: "Test Street"
            ),
            Order(
                id: "2",
                title: "Order 2",
                description: "Test order 2",
                workPerformed: "",
                orderNumber: "124",
                status: .delayed,
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                customerId: "1",
                customerName: "Test Customer",
                customerStreetName: "Test Street"
            ),
            Order( // Lägg till denna completed order
                           id: "3",
                           title: "Completed Order",
                           description: "This order is completed",
                           workPerformed: "",
                           orderNumber: "125",
                           status: .completed,
                           dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                           customerId: "1",
                           customerName: "Test Customer",
                           customerStreetName: "Test Street"
                       )
                   ]
        
        var body: some View {
            MonthCalendarView(selectedDate: $selectedDate, orders: orders)
        }
    }
    return PreviewWrapper()
}
