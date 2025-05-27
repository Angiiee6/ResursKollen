//
//  MessagesManger.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import Foundation
import FirebaseFirestore

final class MessagesManger{
    
    static let shared = MessagesManger()
    private init() {}
    
    private let messagesCollection = Firestore.firestore().collection("messages")
    
    func messagesDocuments()-> DocumentReference{
        return messagesCollection.document()
    }
    
    //Spara ett nytt medd.
    func writeNewMessage(message: Message) async throws{
        try messagesDocuments().setData(from: message, merge: false )
    }
    
    
}
