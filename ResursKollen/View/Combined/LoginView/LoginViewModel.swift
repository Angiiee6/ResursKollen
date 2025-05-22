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
    @Published var email: String = ""
        @Published var password: String = ""
        @Published var isUserLoggedIn = false
       @Published var currentUser: UserData?
        
        
    func signIn(email: String, password: String) async throws {
        
           guard !email.isEmpty && !password.isEmpty else {
         print("Email eller lösenord sakans")
         return
         }
         
         do {
         _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
         let authData = try AuthenticationManager.shared.getAuthenticatedUser()
         currentUser = try await UsersManager.shared.getUser(userId: authData.uid)
         
         
         print("Användaren inloggad")
         isUserLoggedIn = true
         
         
         } catch let error {
         print("inlogning misslyckades \(error)")
         isUserLoggedIn = false
         }
         
         }
    
}
