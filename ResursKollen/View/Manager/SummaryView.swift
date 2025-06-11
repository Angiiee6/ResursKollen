//
//  SummaryView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Charts
import Factory
import SwiftUI

struct SummaryView: View {
    @StateObject var vm = SummaryViewModel()
    @State private var selectedDate = Date()
    @State private var showingCalendar = false
    //MARK: Body
    var body: some View {
        BaseView {
            // Titel
            ScrollView {
                VStack {
                    HStack {
                        Text("Orderöversikt")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        //MARK: Kalender knapp
                        Button(action: {
                            showingCalendar.toggle()
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(
                                    selectedDate.formatted(
                                        .dateTime.month(.wide).year()
                                    )
                                )
                                .font(.subheadline)
                            }
                            .foregroundColor(.orange)
                        }
                        .sheet(isPresented: $showingCalendar) {
                            NavigationStack {
                                MonthCalendarView(
                                    selectedDate: $selectedDate,
                                    orders: vm.orders
                                )
                                .toolbar {
                                    ToolbarItem(
                                        placement: .navigationBarTrailing
                                    ) {
                                        Button("Klar") {
                                            showingCalendar = false
                                        }
                                        .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    //MARK: Chart
                    Chart {
                        ForEach(vm.chartData) { data in
                            BarMark(
                                x: .value("Status", data.status),
                                y: .value("Antal", data.count)
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                    // X Led
                    .chartXAxis {
                        AxisMarks {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                                .foregroundStyle(.white)
                                .font(.caption)
                        }
                    }
                    // Y led
                    .chartYAxis {
                        AxisMarks {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 200)
                    .padding()

                    VStack(alignment: .leading) {
                        Text("Månadens Statistik")
                            .foregroundColor(.white)
                    }

                    // 4 lådorna i botten, behöver fyllas med info
                    HStack(spacing: 50) {
                        ShowCaseView(
                            title: "MaterialKostnad",
                            value: vm.totalMaterialCost,
                            iconName: "cube.box"
                        )
                        ShowCaseView(
                            title: "Arbetade timmar",
                            value: vm.totalHoursString,
                            iconName: "clock"
                        )
                    }

                    HStack(spacing: 50) {
                        ShowCaseView(
                            title: "Arbetskostnad",
                            value: vm.totalLaborCost,
                            iconName: "hammer"
                        )
                        ShowCaseView(
                            title: "Total orderkostnad",
                            value: vm.totalOrderCost,
                            iconName: "hammer"
                        )
                    }

                    ShowCaseView(
                        title: "Profit",
                        value: vm.ProfitThisMonth,
                        iconName: "creditcard"
                    )

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SummaryView()
}

//MARK: ViewModel
extension SummaryView {
    @MainActor
    class SummaryViewModel: ObservableObject {
        @Injected(\.managerDataProvider) var dataProvider: MainDataProvider
        init() {
            dataProvider.$activeOrders.assign(to: &$orders)
        }

        @Published var orders: [Order] = []

        // Hämtar alla timmar som är gjorda på alla ordrar under månaden som är jämfört med när den är skapad, OBS, kan va fel
        var totalHoursString: String {
            let calendar = Calendar.current
            let now = Date()

            let total =
                orders
                .filter {
                    calendar.isDate(
                        $0.creationDate,
                        equalTo: now,
                        toGranularity: .month
                    )
                }
                .compactMap { Int($0.totalTimeWorked) }
                .reduce(0, +)

            return "\(total) h"
        }

        var totalMaterialCost: String {
            let calendar = Calendar.current
            let now = Date()

            let total = orders.filter {
                calendar.isDate(
                    $0.creationDate,
                    equalTo: now,
                    toGranularity: .month
                )
            }
            .compactMap { Int($0.totalMaterialCost) }
            .reduce(0, +)

            return "\(total) kr"
        }

        var totalLaborCost: String {
            let calendar = Calendar.current
            let now = Date()

            let total = orders.filter {
                calendar.isDate(
                    $0.creationDate,
                    equalTo: now,
                    toGranularity: .month
                )
            }
            .compactMap { Int($0.totalLaborCost) }
            .reduce(0, +)

            return "\(total) kr"
        }

        var totalOrderCost: String {
            let calendar = Calendar.current
            let now = Date()

            let total = orders.filter {
                calendar.isDate(
                    $0.creationDate,
                    equalTo: now,
                    toGranularity: .month
                )
            }
            .compactMap { Int($0.totalOrderCost) }
            .reduce(0, +)

            return "\(total) kr"
        }
        //MARK: Vinst denna månaden
        // Tar fram vinsten denna månaden.
        var ProfitThisMonth: String {
            let calendar = Calendar.current
            let now = Date()

            let ordersThisMonth =
                orders
                .filter {
                    calendar.isDate(
                        $0.creationDate,
                        equalTo: now,
                        toGranularity: .month
                    )
                }

            let material = ordersThisMonth.compactMap { $0.totalMaterialCost }
                .reduce(0, +)
            let labor = ordersThisMonth.compactMap { $0.totalLaborCost }.reduce(
                0,
                +
            )
            let total = ordersThisMonth.compactMap { $0.totalOrderCost }.reduce(
                0,
                +
            )

            let profit = total - material + labor

            return "\(Int(profit)) kr"
        }
        //MARK: Gruppera ordrar
        // grupperar orders beroende på status och visar i charten
        // Gjort en klass för att göra det mer läsbart och snyggare
        var chartData: [OrderChartData] {
            let grouped = Dictionary(grouping: orders, by: { $0.status })

            return [
                OrderChartData(
                    status: "Tilldelade",
                    count: grouped[.started]?.count ?? 0
                ),
                OrderChartData(
                    status: "Försenade",
                    count: grouped[.delayed]?.count ?? 0
                ),
                OrderChartData(
                    status: "Avslutade",
                    count: grouped[.completed]?.count ?? 0
                ),
                OrderChartData(
                    status: "registrerade",
                    count: grouped[.registered]?.count ?? 0
                ),
            ]
        }
    }
}
