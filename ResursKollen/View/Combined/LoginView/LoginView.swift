//
//  LoginView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
//  2025-005-19 Daniel A
//  Skapade en viewmodelfil

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewViewmodel
    //för logga in knappens utseende
    @State private var isLoggingIn = false
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ///BaseView för bakgrund
        BaseView {
            VStack(spacing: 0) {
                Image("ResursKollenLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                VStack(spacing: 20) {
                    // Rubrik med ikon
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                        Text("Logga in")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                    // Email-fält
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.orange)
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                    )

                    // Lösenord-fält
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.orange)
                        //för att inte visa lösenordet
                        SecureField("Lösenord", text: $password)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                    )

                    // Logga in-knapp
                    Button(action: {
                        // Hantera inloggning, blir true i 2 sek, sedan false igen
                        isLoggingIn = true
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        Task {
                            do {
                                try await viewModel.signIn(
                                    email: email,
                                    password: password
                                )
                                return
                            } catch {
                                //lämpligt felmedd. om vi kastar
                            }
                        }
                        isLoggingIn = false
                        //}
                    }) {
                        HStack {
                            //Laddningsindikator vid knapptryck
                            if isLoggingIn {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Logga in")
                                    .fontWeight(.bold)
                            }
                        }
                        //Logga in-knappens utseende
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .disabled(isLoggingIn)

                    // Glömt lösenord-knapp
                    Button(action: {}) {
                        Text("Glömt lösenord?")
                            .foregroundColor(.orange)
                            .font(.footnote)
                    }
                    .padding(.top, 10)
                }
                //Hela containerns utseende
                .padding(30)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.horizontal)
                Spacer()

                //TODO: Remove this after testing.
                VStack {
                    Text("Test-logins:")
                        .foregroundStyle(.pink)
                    HStack {
                        Button("Bossen") {
                            Task {
                                do {
                                    try await viewModel.signIn(
                                        email: "bossen@test.se",
                                        password: "KalleAnka"
                                    )
                                } catch {}

                            }
                        }
                        Button("Johan") {
                            Task {
                                do {
                                    try await viewModel.signIn(
                                        email: "johan@test.se",
                                        password: "KalleAnka"
                                    )
                                } catch {}
                            }

                        }
                    }
                }
            }
        }
    }

}

#Preview {
    LoginView(viewModel: LoginViewViewmodel())
}
