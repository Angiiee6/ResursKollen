//
//  AddCustomerSheet.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-06-02.
//

import MapKit
import SwiftUI

struct AddCustomerSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()

    @State var alertIsPresent = false

    @State var name: String = ""
    @State var phone: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            Form {
                Section("Kundinformation") {
                    TextField("Namn", text: $name)
                    TextField("Gata", text: $viewModel.streetName)
                    TextField("Postkod", text: $viewModel.postalCode)
                    TextField("Stad", text: $viewModel.city)
                    TextField("Telefonnummer", text: $phone)
                    TextField("Emailadress", text: $email)
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.updateSearchQuery(newValue)
            }
            Text("Sök adress:")
            TextField("Adress", text: $viewModel.searchText)
            if !viewModel.searchSuggestions.isEmpty {
                VStack {
                    Text("Välj adress:")
                    List(viewModel.searchSuggestions, id: \.self) { suggestion in
                        Button {
                            viewModel.selectAddress(suggestion)
                            viewModel.searchText.removeAll()
                        }
                        label: {
                            VStack(alignment: .leading) {
                                Text(suggestion.title)
                                Text(suggestion.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            Spacer()
            Button("Spara") {
                Task {
                    let newCustomer = Customer(
                        name: name,
                        phoneNumber: phone,
                        streetName: viewModel.streetName,
                        city: viewModel.city,
                        postalCode: viewModel.postalCode,
                        emailAddress: email
                    )
                    await viewModel.saveCustomer(newCustomer)
                    alertIsPresent = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("Meddelande", isPresented: $alertIsPresent) {
            Button("Ok") {
                dismiss()
            }

        } message: {
            Text(viewModel.alertMessage)
        }

    }
}

//MARK: View model

extension AddCustomerSheet {

    class ViewModel: NSObject, ObservableObject {
        
        @Published var searchText: String = ""
        @Published var searchSuggestions: [MKLocalSearchCompletion] = []
        
        @Published var streetName: String = ""
        @Published var postalCode: String = ""
        @Published var city: String = ""
        
        private var completer = MKLocalSearchCompleter()
        
        var alertMessage: String = ""
        
        override init() {
            super.init()
            completer.resultTypes = .address
            completer.delegate = self
        }
        
        func saveCustomer(_ customer: Customer) async {
            do {
                try await FirestoreManager.shared.saveCustomer(customer)
                alertMessage = "Ny kund tillagd!"
            } catch {
                alertMessage =
                "Något gick fel - kund kunde inte sparas: \(error.localizedDescription)"
            }
        }
        
        func updateSearchQuery(_ query: String) {
            searchText = query
            completer.queryFragment = query
            if query.isEmpty {
                searchSuggestions.removeAll()
            }
        }
        
        func selectAddress(_ completion: MKLocalSearchCompletion) {
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let placemark = response?.mapItems.first?.placemark, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "No data")")
                    return
                }
                let street = placemark.thoroughfare ?? ""
                let number = placemark.subThoroughfare ?? ""
                self.streetName =  "\(street) \(number)"
                self.postalCode = placemark.postalCode ?? ""
                self.city = placemark.locality ?? ""
            }
            
        }
    }

}

extension AddCustomerSheet.ViewModel: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchSuggestions = completer.results
    }

    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: any Error
    ) {
        print("Address search error: \(error.localizedDescription)")
    }
    
}

#Preview {
    AddCustomerSheet()
}
