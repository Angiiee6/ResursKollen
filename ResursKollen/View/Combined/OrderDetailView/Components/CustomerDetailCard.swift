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
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            //MARK: Name
            Text(customer.name)
                .font(.headline)
            
            //MARK: Address
            //Klickbar address
            Button(action: {
                customer.openInMaps()
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.streetName)
                    Text("\(customer.postalCode) \(customer.city)")
                }
                .foregroundColor(.blue)
                .underline()  // Understruket för tydlighet
            }
            //MARK: Phone number
            Button(action: {
                showOptions = true
            }) {
                Text(customer.phoneNumber)
                    .foregroundColor(.blue)
            }
            // När du trycker på nummret så kommer 3 alternativ upp
            .confirmationDialog("Vad vill du göra?", isPresented: $showOptions)
            {
                Button("Ringa") {
                    viewModel.callNumber(customer.phoneNumber)
                }
                Button("Skicka SMS") {
                    viewModel.sendSMS(customer.phoneNumber)
                }
                Button("Avbryt", role: .cancel) {}
            }
            //MARK: Email
            if !customer.emailAddress.isEmpty {
                Button {
                    viewModel.sendMail(to: customer.emailAddress)
                }
                label: {
                    Image(systemName: "envelope.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
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
  
}

extension CustomerDetailCard {
    //MARK: ViewModel
    class ViewModel : ObservableObject {
        
        // funktion för att ringa
         func callNumber(_ number: String) {
            let cleaned = number.filter { $0.isNumber }
            if let url = URL(string: "tel://\(cleaned)"),
                UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            } else {
                print(" Kunde inte ringa numret: \(number)")
            }
        }

        //  Funktion för att skicka sms
         func sendSMS(_ number: String) {
            let cleaned = number.filter { $0.isNumber }
            if let url = URL(string: "sms:\(cleaned)"),
                UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            } else {
                print(" Kunde inte öppna SMS till: \(number)")
            }
        }

         func sendMail(to address: String) {
            let trimmedAddress = address.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            // Email format validation
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

            guard !trimmedAddress.isEmpty, predicate.evaluate(with: trimmedAddress)
            else {
                print("Invalid email address")
                return
            }
            //Ensure format of special characters like '@' is properly formatted for URL
            let mailto = "mailto:\(trimmedAddress)".addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            )!
            if let url = URL(string: mailto), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cannot open mail app")
            }
        }
        
    }
    
}

#Preview {
    CustomerDetailCard(
        customer: Customer(
            name: "Anna Andersson",
            phoneNumber: "070123456",
            orders: [],
            streetName: "Kungsgatan 27",
            city: "Uppsala",
            postalCode: "75621",
            emailAddress: "annaandersson@gmail.com"
        )
    )
}
