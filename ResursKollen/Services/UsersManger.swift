//
//  UsersManger.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-19.
//

import FirebaseFirestore
import Foundation

final class UsersManager {

    static let shared = UsersManager()
    private init() {}

    private let usercollection = Firestore.firestore().collection("users")

    // encoder and decoder. Converts to and from snake case for database standard
    private let encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // userDocuments, get usersdocuments from path userCollection.document(userId)
    func userDocuments(userId: String) -> DocumentReference {
        return usercollection.document(userId)
    }

    // createNewUser, creates a new user from type UserData
    func createNewUser(user: UserData) async throws {
        try userDocuments(userId: user.id).setData(from: user, merge: false, encoder: encoder
        )
    }

    // getUser, gets the full user inforamtions returned in a UderData object
    func getUser(userId: String) async throws -> UserData {
        try await userDocuments(userId: userId).getDocument(as: UserData.self, decoder: decoder)
    }

}
