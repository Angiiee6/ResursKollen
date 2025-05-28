//
//  MessagesManger.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import Foundation
import FirebaseFirestore

final class MessagesManager{
    
    static let shared = MessagesManager()
    private init() {}
    
    private let messagesCollection = Firestore.firestore().collection("messages")
    
    func messagesDocuments()-> DocumentReference{
        return messagesCollection.document()
    }
    
    //Spara ett nytt medd.
    func writeNewMessage(message: Message) async throws{
        try messagesDocuments().setData(from: message, merge: false )
    }
    
    //läs alla medd.
    func readAllmessages()async throws -> [Message] {
        let snapshot = try await Firestore.firestore().collection("messages").getDocuments()
        
            let messages  = snapshot.documents.compactMap { doc in
                try? doc.data(as: Message.self)
            }
            return messages
        
    }
    
    
}
