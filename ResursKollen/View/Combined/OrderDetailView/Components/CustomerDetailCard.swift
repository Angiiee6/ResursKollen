//
//  CustomerDetailCard.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import SwiftUI

struct CustomerDetailCard: View {
    let customer: Customer
    @State var showOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(customer.name)
                .font(.headline)
            //Klickbar address
            Button(action: {
                customer.openInMaps()
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.streetName)
                    Text("\(customer.postalCode) \(customer.city)")
                }
                .foregroundColor(.blue)
                .underline() // Understruket för tydlighet
            }
            Button(action: {
                showOptions = true
            }) {
                
                Text(customer.phoneNumber)
                    .foregroundColor(.blue)
            }
            // När du trycker på nummret så kommer 3 alternativ upp
            .confirmationDialog("Vad vill du göra?", isPresented: $showOptions) {
                Button("Ringa") {
                    callNumber(customer.phoneNumber)
                }
                Button("Skicka SMS") {
                    sendSMS(customer.phoneNumber)
                }
                Button("Avbryt", role: .cancel) {}
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange, lineWidth: 2)
        )
        
    }
    // funktion för att ringa
    private func callNumber(_ number: String) {
        let cleaned = number.filter { $0.isNumber }
        if let url = URL(string: "tel://\(cleaned)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print(" Kunde inte ringa numret: \(number)")
        }
    }
    
    //  Funktion för att skicka sms
    private func sendSMS(_ number: String) {
        let cleaned = number.filter { $0.isNumber }
        if let url = URL(string: "sms:\(cleaned)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print(" Kunde inte öppna SMS till: \(number)")
        }
    }
}


#Preview {
    CustomerDetailCard(customer: Customer(name: "Anna Andersson", phoneNumber: "070123456", orders: [], streetName: "Kungsgatan 27", city: "Uppsala", postalCode: "75621", emailAddress: "annaandersson@gmail.com"))
}
