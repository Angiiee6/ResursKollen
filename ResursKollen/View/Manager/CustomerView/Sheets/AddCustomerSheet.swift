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
    @State var showSuggestions = false
    @FocusState var streetNameTextFieldIsFocused: Bool

    @State var name: String = ""
    @State var phone: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            Text("Lägg till ny kund")
                .font(.title)
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    if !showSuggestions {
                        VStack(alignment: .leading) {
                            Text("Namn: *")
                                .font(.caption)
                            TextField("Namn", text: $name)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Adress: *")
                            .font(.caption)
                        VStack(alignment: .leading) {
                            TextField("Gata", text: $viewModel.searchText)
                                .focused($streetNameTextFieldIsFocused)
                                .onSubmit {
                                    animateSuggestions(shown: false)
                                }
                            if !showSuggestions {
                                TextField(
                                    "Postkod",
                                    text: $viewModel.postalCode
                                )
                                TextField("Stad", text: $viewModel.city)
                            }
                        }
                        .font(.subheadline)
                    }
                    if !showSuggestions {
                        VStack(alignment: .leading) {
                            Text("Telefonnummer: *")
                                .font(.caption)
                            TextField("Telefonnummer", text: $phone)
                                .keyboardType(.phonePad)
                        }
                        VStack(alignment: .leading) {
                            Text("Email:")
                                .font(.caption)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .onChange(of: viewModel.searchText) { _, newSearchString in
                animateSuggestions(shown: !newSearchString.isEmpty)
                viewModel.updateSearchQuery(newSearchString)
            }
            .onChange(of: streetNameTextFieldIsFocused) { _, isFocused in
                self.animateSuggestions(shown: false)
            }
            if showSuggestions {
                VStack {
                    List(viewModel.searchSuggestions, id: \.self) {
                        suggestion in
                        Button {
                            viewModel.selectAddress(suggestion)
                            animateSuggestions(shown: false)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(suggestion.title)
                                Text(suggestion.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
            if !showSuggestions {
                Button("Spara") {
                    Task {
                        let newCustomer = Customer(
                            name: name,
                            phoneNumber: phone,
                            streetName: viewModel.searchText,
                            city: viewModel.city,
                            postalCode: viewModel.postalCode,
                            emailAddress: email
                        )
                        await viewModel.saveCustomer(newCustomer)
                        alertIsPresent = true
                    }
                }
                .disabled(
                    name.isEmpty || viewModel.searchText.isEmpty
                    || viewModel.postalCode.isEmpty || viewModel.city.isEmpty
                    || phone.isEmpty
                )
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .alert("Meddelande", isPresented: $alertIsPresent) {
            Button("Ok") {
                dismiss()
            }

        } message: {
            Text(viewModel.alertMessage)
        }

    }

    private func animateSuggestions(shown: Bool) {
        withAnimation(.easeInOut(duration: 0.5)) {
            showSuggestions = shown
        }

    }
}

//MARK: View model

extension AddCustomerSheet {

    class ViewModel: NSObject, ObservableObject {

        @Published var searchText: String = ""
        @Published var searchSuggestions: [MKLocalSearchCompletion] = []

        //@Published var streetName: String = ""
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
            //            if query.isEmpty {
            //                searchSuggestions.removeAll()
            //            }
        }

        func selectAddress(_ completion: MKLocalSearchCompletion) {
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let placemark = response?.mapItems.first?.placemark,
                    error == nil
                else {
                    print("Error: \(error?.localizedDescription ?? "No data")")
                    return
                }
                let street = placemark.thoroughfare ?? ""
                let number = placemark.subThoroughfare ?? ""
                self.searchText = "\(street) \(number)"
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
