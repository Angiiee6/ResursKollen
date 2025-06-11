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
    
    // Beräknad egenskap som kontrollerar om alla obligatoriska fält är ifyllda
    var allRequiredFieldsFilled: Bool {
        !name.isEmpty &&
        !phone.isEmpty &&
        !viewModel.searchText.isEmpty &&
        !viewModel.postalCode.isEmpty &&
        !viewModel.city.isEmpty
    }

    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    // Header with icon
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .font(.largeTitle)
                        Text("Ny Kund")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Contact Information Section - Visas bara när inte i adressläge
                            if !streetNameTextFieldIsFocused && !showSuggestions {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Kunduppgifter")
                                        .font(.headline)
                                        .foregroundColor(.orange.opacity(0.8))
                                        .padding(.leading, 5)
                                    
                                    inputField(icon: "person", placeholder: "Namn: *", text: $name)
                                    
                                    inputField(icon: "phone", placeholder: "Telefonnummer: *", text: $phone)
                                        .keyboardType(.phonePad)
                                    
                                    inputField(icon: "envelope", placeholder: "E-post", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            // Address Section - Alltid synlig
                            VStack(alignment: .leading) {
                                Text("Adressuppgifter: *")
                                    .font(.headline)
                                    .foregroundColor(.orange.opacity(0.8))
                                    .padding(.leading, 5)
                                
                                inputField(icon: "house", placeholder: "Gata", text: $viewModel.searchText)
                                    .focused($streetNameTextFieldIsFocused)
                                    .onSubmit {
                                        animateSuggestions(shown: false)
                                    }
                                
                                if !showSuggestions && !streetNameTextFieldIsFocused {
                                    inputField(icon: "signpost.right", placeholder: "Postkod", text: $viewModel.postalCode)
                                    inputField(icon: "building", placeholder: "Stad", text: $viewModel.city)
                                }
                            }
                            
                            // Adressförslag - Visas bara vid sökning
                            if showSuggestions {
                                VStack(alignment: .leading) {
                                    Text("Förslag")
                                        .font(.headline)
                                        .foregroundColor(.orange.opacity(0.8))
                                        .padding(.leading, 5)
                                    
                                    VStack(spacing: 0) {
                                        ForEach(viewModel.searchSuggestions.prefix(5), id: \.self) { suggestion in
                                            Button {
                                                viewModel.selectAddress(suggestion)
                                                animateSuggestions(shown: false)
                                                streetNameTextFieldIsFocused = false
                                            } label: {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    HStack {
                                                        Image(systemName: "mappin.and.ellipse")
                                                            .foregroundColor(.orange)
                                                        Text(suggestion.title)
                                                            .foregroundColor(.white)
                                                            .font(.subheadline)
                                                        Spacer()
                                                    }
                                                    Text(suggestion.subtitle)
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                        .padding(.leading, 24)
                                                }
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 15)
                                            }
                                            
                                            if suggestion != viewModel.searchSuggestions.prefix(5).last {
                                                Divider()
                                                    .background(Color.white.opacity(0.2))
                                                    .padding(.leading, 15)
                                            }
                                        }
                                    }
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .padding(.top, 10)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            //MARK: Knappar
                            // Knappar - Visas bara när inte i adressläge
                            if !streetNameTextFieldIsFocused && !showSuggestions {
                                    Button {
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
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark")
                                            Text("Spara")
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle(
                    backgroundColor: allRequiredFieldsFilled ? .orange : .gray
                                                                      ))
                                    .disabled(!allRequiredFieldsFilled)
                                
                                .padding(.top, 20)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .onChange(of: viewModel.searchText) { _, newSearchString in
                    animateSuggestions(shown: !newSearchString.isEmpty)
                    viewModel.updateSearchQuery(newSearchString)
                }
                .onChange(of: streetNameTextFieldIsFocused) { _, isFocused in
                    withAnimation {
                        showSuggestions = isFocused && !viewModel.searchText.isEmpty
                    }
                }
                .alert("Meddelande", isPresented: $alertIsPresent) {
                    Button("Ok") {
                        dismiss()
                    }
                } message: {
                    Text(viewModel.alertMessage)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func animateSuggestions(shown: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showSuggestions = shown
        }
    }
    
    private func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange.opacity(0.7))
            TextField(placeholder, text: text)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
    
    private struct PrimaryButtonStyle: ButtonStyle {
        var backgroundColor: Color
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor.opacity(configuration.isPressed ? 0.7 : 1.0))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}

//MARK: View model

extension AddCustomerSheet {

    class ViewModel: NSObject, ObservableObject {

        @Published var searchText: String = ""
        @Published var searchSuggestions: [MKLocalSearchCompletion] = []

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
