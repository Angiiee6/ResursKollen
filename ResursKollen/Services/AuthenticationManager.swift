import FirebaseAuth
//
//  Authentication.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {

    static let shared = AuthenticationManager()  //Singelton kanske inte det bästa men vi kör på det

    private init() {}

    //SignInUser
    @discardableResult
    func signInUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {

        let authDataResult = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

    //SignOut
    func signOut() throws {
        try Auth.auth().signOut()
    }

    //Create new user
    @discardableResult
    func addUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

    //Delete user
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthErrorCode.invalidEmail
        }
        try await user.delete()
    }

    //Reset Password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

}
