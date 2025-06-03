//
//  CustomerDetailCard.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-22.
//

import SwiftUI

struct CustomerDetailCard: View {
    @State var showOptions = false
    @StateObject var viewModel: ViewModel

    init(customerId: String) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(customerId: customerId)
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                VStack {
                    Group {
                        Text("Något gick fel:")
                        Text(error.localizedDescription)
                            .foregroundStyle(.red)
                    }
                    .font(.caption2)
                    Button("Försök igen") {

                    }
                }

            case .hasData(let customer):

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
                .confirmationDialog(
                    "Vad vill du göra?",
                    isPresented: $showOptions
                ) {
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
                    } label: {
                        Image(systemName: "envelope.circle.fill")
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
        }
        //MARK: Task
        .task {
            Task {
                await viewModel.fetchCustomerData()
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
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
    @MainActor
    class ViewModel: ObservableObject {
        let customerId: String

        @Published var state: CustomerDataState = .loading

        init(customerId: String) {
            self.customerId = customerId
        }

        enum CustomerDataState {
            case loading
            case error(Error)
            case hasData(Customer)
        }

        func fetchCustomerData() async {
            state = .loading
            do {
                let customer = try await FirestoreManager.shared.fetchCustomer(
                    id: customerId
                )
                state = .hasData(customer)
            } catch {
                state = .error(error)
            }
        }

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

            guard !trimmedAddress.isEmpty,
                predicate.evaluate(with: trimmedAddress)
            else {
                print("Invalid email address")
                return
            }
            //Ensure format of special characters like '@' is properly formatted for URL
            let mailto = "mailto:\(trimmedAddress)".addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            )!
            if let url = URL(string: mailto),
                UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            } else {
                print("Cannot open mail app")
            }
        }

    }

}

#Preview {
    CustomerDetailCard(
        customerId: "123456"
    )
}
