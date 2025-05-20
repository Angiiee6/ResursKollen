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
    
    var body: some View {
        VStack {
            
          
                
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
        
        func GetOrders() {
            db.listenToOrderCollection { [weak self ] newOrders in
                DispatchQueue.main.async {
                    self?.orders = newOrders
                }
                
            }
        }
        
        
    }
}
