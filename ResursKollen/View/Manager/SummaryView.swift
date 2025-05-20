//
//  SummaryView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI
import Charts

struct SummaryView: View {
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    
    @StateObject var vm = SummaryViewModel()
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
            VStack {
                Text("Orderöversikt")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                
                // Chart
                Chart {
                    ForEach(vm.chartData) {data in
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
                
                HStack(spacing: 50) {
                    ShowCaseView(value: vm.totalHoursString)
                    ShowCaseView(value: vm.totalHoursString)
                }
                HStack(spacing: 50) {
                    ShowCaseView(value: vm.totalHoursString)
                    ShowCaseView(value: vm.totalHoursString)
                    
                    
                    }
                Spacer()
                }
            }
        }
    }


#Preview {
    SummaryView()
}

extension SummaryView {
    
    class SummaryViewModel: ObservableObject {
        let db = FirestoreManager()
        
        @Published var orders : [Order] = []
        
        var totalHoursString: String {
            let total = orders
                .compactMap { Int($0.timeConsumption) }
                .reduce(0, +)
            return "\(total) h"
        }
        
        init() {
            GetOrders()
        }
        
        func GetOrders() {
            db.listenToOrderCollection { [weak self ] newOrders in
                DispatchQueue.main.async {
                    self?.orders = newOrders
                }
                
            }
        }
        
        var chartData: [OrderChartData] {
            let grouped = Dictionary(grouping: orders, by: {$0.status})
            
            return [
                OrderChartData(status: "Påbörjade", count: grouped[.started]?.count ?? 0),
                OrderChartData(status: "Försenade", count: grouped[.delayed]?.count ?? 0),
                OrderChartData(status: "Avslutade", count: grouped[.completed]?.count ?? 0),
                OrderChartData(status: "registrerade", count: grouped[.registered]?.count ?? 0)
            ]
        }
        
        
    }
}

