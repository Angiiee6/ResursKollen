//
//  SummaryView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI
import Charts

struct SummaryView: View {
    
    let dummyOrders : [String] = ["Hej","Hejehej","Robin","HAERKJAH"]
    @StateObject var vm = SummaryViewModel()
    var body: some View {
        VStack {
            Text("Orderöversikt")
                .font(.title)
                .bold()
            
            Chart {
                ForEach(vm.chartData) {data in
                    BarMark(
                        x: .value("Status", data.status),
                        y: .value("Antal", data.count)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 200)
            .padding()
            Spacer()
            
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
