//
//  LoginView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    //för logga in knappens utseende
    @State private var isLoggingIn = false
    
    var body: some View {
        ZStack {
            
            ///bakgrund
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.11, green: 0.11, blue: 0.15),Color(red: 0.20, green: 0.20, blue: 0.25)]),startPoint: .top,endPoint: .bottom).edgesIgnoringSafeArea(.all)

            
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
                        .foregroundColor(.white.opacity(0.7))
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
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                
                // Lösenord-fält
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.white.opacity(0.7))
                    //för att inte visa lösenordet
                    SecureField("Lösenord", text: $password)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                
                // Logga in-knapp
                Button(action: {
                    // Hantera inloggning, blir true i 2 sek, sedan false igen
                    isLoggingIn = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoggingIn = false
                    }
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
                            .stroke(Color.black.opacity(0.9), lineWidth: 1)
                    )
                }
                .disabled(isLoggingIn)
                
                
                
                // Glömt lösenord-knapp
                Button(action: {}) {
                    Text("Glömt lösenord?")
                        .foregroundColor(.white)
                        .font(.footnote)
                }
                .padding(.top, 10)
            }
            //Hela containerns utseende
            .padding(30)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(20)
        }

    }
}


#Preview {
    LoginView()
}
