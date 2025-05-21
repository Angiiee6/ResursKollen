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
    @Published var isUserManager = false
    @Published var isUserLoggedIn = false
    
    
    func signIn() async throws {
        
        guard !email.isEmpty && !password.isEmpty else {
            print("Email eller lösenord sakans")
            return
        }
        
        do {
            _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            print("Användaren inloggad")
            isUserLoggedIn = true
        } catch let error {
            print("inlogning misslyckades \(error)")
            isUserLoggedIn = false
        }
        
        let userPosition = await checkUserPostion()
        print("userPosition: \(userPosition)")
        print("isUserManager: \(isUserManager)")
        print("isUserLoggedIn: \(isUserLoggedIn)")
        
        if userPosition == .manager {
            isUserManager = true
        }else {
            isUserManager = false
        }
        
        
        
    }
    func checkUserPostion() async  -> EmploymentStatus {
        
        do{
            let authdata = try AuthenticationManager.shared.getAuthenticatedUser()
            let user = try await UsersManager.shared.getUser(userId: authdata.uid)
            
            switch user.status {
            case .employee:
                return .employee
            case .manager:
                return .manager
            case .unknown:
                return .unknown
            }
            }catch let error {
                print(error)
            }
        return .unknown
        }
        
    }



