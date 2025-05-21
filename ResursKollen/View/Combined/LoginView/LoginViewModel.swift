//
//  LoginViewModel.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-21.
//

import Foundation
import SwiftUI

@MainActor
final class LoginViewViewmodel: ObservableObject {

    @Published var currentUser: UserData?

    func signIn(email: String, password: String) async throws {

        guard !email.isEmpty && !password.isEmpty else {
            print("Email eller lösenord sakans")
            return
        }

        do {
            let authDataResult = try await AuthenticationManager.shared
                .signInUser(email: email, password: password)
            //Uppdatera currentUser efter inlogg
            currentUser = try await FirestoreManager.shared.fetchUserData(
                userId: authDataResult.user.uid
            )
            print("Användaren inloggad")
        } catch let error {
            print("inlogning misslyckades \(error)")

        }
    }
}
