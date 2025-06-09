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

    

    // userDocuments, get usersdocuments from path userCollection.document(userId)
    func userDocuments(userId: String) -> DocumentReference {
        return usercollection.document(userId)
    }

    // createNewUser, creates a new user from type UserData
    func createNewUser(user: UserData) async throws {
        try userDocuments(userId: user.id).setData(from: user, merge: false)   // enconder: endcoder
    }

    // getUser, gets the full user inforamtions returned in a UserData object
    func getUser(userId: String) async throws -> UserData {
        try await userDocuments(userId: userId).getDocument(as: UserData.self) // decoder: decoder)
    }
    
    // getAllUser, gets all users from database
    func getAllUser() async throws -> [UserData] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        
            let users = snapshot.documents.compactMap { doc in
                try? doc.data(as: UserData.self)
            }
            return users
    }
    //Update a User
    func updateUser(user: UserData) async throws {
        try  userDocuments(userId: user.id).setData(from: user, merge: true)
    }
    
    //Snapshot lyssnare för users kollektionen
    func listenToUserChanges(onUpdate: @escaping (Result<[UserData], Error>) -> Void) -> ListenerRegistration {
        usercollection.addSnapshotListener { snapShot, error in
            if let error = error {
                print ("Error listening to users: \(error)")
                onUpdate(.failure(error))
                return
            }
            
            guard let documents = snapShot?.documents else {
                print("No Documents")
                onUpdate(.success([]))
                return
            }
            
            let users = documents.compactMap { doc in
                try? doc.data(as: UserData.self)
            }
            
            onUpdate(.success(users))
            
        }
    }
    
}
