//
//  AddEmployeeView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-20.
//

import SwiftUI

class AddEmployeeViewModel: ObservableObject {
    @Published var user = UserData()
    @Published var password = ""
    let anstNr = UserData.generateEmploymentNumber()
    
    func createNewEmployee() async throws {
        guard !user.email.isEmpty && !user.email.isEmpty else {
            print("Saknar E-post adress eller lösenord")
            return
        }
        let authData = try await AuthenticationManager.shared.addUser(
            email: user.email,
            password: password
        )
        
        let newUser = UserData(
            id: authData.user.uid,
            status: user.status,
            name: user.name,
            email: authData.user.email ?? "",
            employmentDate: user.employmentDate,
            employmentNumber: anstNr,
            phoneNumber: user.phoneNumber
        )

        try await UsersManager.shared.createNewUser(user: newUser)
    }
}

struct AddEmployeeView: View {
    @StateObject private var viewModel = AddEmployeeViewModel()
    @State private var isManager = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient matching LoginView
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.11, green: 0.11, blue: 0.15),
                        Color(red: 0.20, green: 0.20, blue: 0.25),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header with icon
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .font(.largeTitle)
                        Text("Ny Anställd")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Contact Information Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Kontaktuppgifter")
                                    .font(.headline)
                                    .foregroundColor(.orange.opacity(0.8))
                                    .padding(.leading, 5)
                                
                                inputField(icon: "person", placeholder: "För- och efternamn", text: $viewModel.user.name)
                        
                                inputField(icon: "phone", placeholder: "Telefonnummer", text: $viewModel.user.phoneNumber)
                                    .keyboardType(.phonePad)
                                inputField(icon: "envelope", placeholder: "E-post", text: $viewModel.user.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                secureInputField(icon: "lock", placeholder: "Lösenord", text: $viewModel.password)
                                
                            }
                            // Employment Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Anställning")
                                    .font(.headline)
                                    .foregroundColor(.orange.opacity(0.8))
                                    .padding(.leading, 5)
                                
                                HStackWithIcon(icon: "calendar") {
                                    DatePicker(
                                        "Anställningsdatum",
                                        selection: $viewModel.user.employmentDate,
                                        displayedComponents: .date
                                    )
                                    .foregroundColor(.black.opacity(0.7))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                                
                                HStack {
                                    Image(systemName: "number")
                                        .foregroundColor(.orange.opacity(0.7))
                                    Text("Anställningsnummer: \(viewModel.anstNr)")
                                        .foregroundColor(.black.opacity(0.7))
                                    Spacer()
                                    
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                                
                                Toggle(isOn: $isManager) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.orange.opacity(0.7))
                                        Text("Chef eller liknande?")
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    
                                }
                                .onChange(of: isManager) { _, newValue in
                                    viewModel.user.status = newValue ? .manager : .employee
                                    
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                            }
                            
                            // Buttons
                            HStack(spacing: 20) {
                                Button {
                                    dismiss()
                                } label: {
                                    HStack {
                                        Image(systemName: "xmark")
                                        Text("Avbryt")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle(backgroundColor: .red))
                                
                                Button {
                                    Task {
                                        do {
                                            try await viewModel.createNewEmployee()
                                            dismiss()
                                        } catch {
                                            print("Fel: Kunde inte spara ny anställd – \(error)")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "checkmark")
                                        Text("Spara")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle(backgroundColor: .orange))
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange.opacity(0.7))
            TextField(placeholder, text: text)
                .foregroundColor(.black.opacity(0.7))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
    
    private func secureInputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange.opacity(0.7))
            SecureField(placeholder, text: text)
                .foregroundColor(.black.opacity(0.7))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
    
    private struct HStackWithIcon<Content: View>: View {
        let icon: String
        let content: () -> Content
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.orange.opacity(0.7))
                content()
            }
        }
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

#Preview {
    AddEmployeeView()
}
