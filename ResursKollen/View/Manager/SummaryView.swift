//
//  SummaryView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Charts
import SwiftUI

struct SummaryView: View {
    @ObservedObject var dataProvider : AppDataProvider
    @StateObject var vm : SummaryViewModel
    
    init(dataProvider: AppDataProvider) {
        self.dataProvider = dataProvider
        _vm = StateObject(wrappedValue: SummaryViewModel(dataProvider: dataProvider))
    }

   

    var body: some View {
        ZStack {
            //Bakgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            ).edgesIgnoringSafeArea(.all)
            // Titel
            ScrollView {
                VStack {
                    Text("Orderöversikt")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()

                    // Chart
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
    SummaryView(dataProvider: AppDataProvider(currentUser: UserData(name: "Test user")))
}

extension SummaryView {

    class SummaryViewModel: ObservableObject {

       init(dataProvider: AppDataProvider) {
            dataProvider.$allOrders.assign(to: &$orders)
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

        // grupperar orders beroende på status och visar i charten
        // Gjort en klass för att göra det mer läsbart och snyggare
        var chartData: [OrderChartData] {
            let grouped = Dictionary(grouping: orders, by: { $0.status })

            return [
                OrderChartData(
                    status: "Påbörjade",
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
