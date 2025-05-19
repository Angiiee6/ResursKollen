//
//  EmployeeHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct EmployeeHomeView: View {
    @StateObject private var vm = EmployeeHomeViewModel()
    
    var body: some View {
        ZStack {
            //Bakgrund
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.11, green: 0.11, blue: 0.15),Color(red: 0.20, green: 0.20, blue: 0.25)]),startPoint: .top,endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack {
                // CardView med announcment från chef
                ManagerHomeView()
                
                List(vm.orders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(order.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(order.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("Status: \(order.status.nameSE)")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Text("Deadline: \(order.dueDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding()
            }
        }
    }
}

#Preview {
    EmployeeHomeView()
}

extension EmployeeHomeView {
    
    class EmployeeHomeViewModel: ObservableObject {
        private let firestore = FirestoreManager()
        
        @Published var orders : [Order] = []
        
        init() {
            listenToOrderCollection()
        }
        
        func listenToOrderCollection() {
            let orderRef = firestore.orderRef
            
            orderRef.addSnapshotListener {snapshot, error in
                if let error = error {
                    print("Error listening to Orders: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.orders = documents.compactMap { doc in
                    try? doc.data(as: Order.self)
                }
                
            }
        }
        
    }
}
