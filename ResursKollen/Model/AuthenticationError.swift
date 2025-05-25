//
//  AuthenticationError.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-21.
//

import Foundation


/// For handling error with authentication on Firebase.
enum AuthenticationError: Error, LocalizedError {
    case currentUserError
    
    var errorDescription: String? {
        switch self {
        case .currentUserError:
            "Could not resolve current Firebase user."
        }
    }
    
}
