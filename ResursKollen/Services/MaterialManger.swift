//
//  MaterialManger.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import Foundation
import FirebaseFirestore

/*
 Handles all items data to and from Firebase
*/
final class MaterialManager {
    
    static let shared = MaterialManager()
    private init() {}
    
    
    
    private let materialColletion = Firestore.firestore().collection("material")
    
    func materialDocuments(material: Material) -> DocumentReference {
        return materialColletion.document(material.id)
    }
    
    //create new material post
    func writeNewMaterialPost(material: Material)async throws{
        try materialDocuments(material: material).setData(from: material, merge: false)
    }
    
    //fetch all stored items
    func readMaterialList() async throws -> [Material] {
        
        let snapshot = try await Firestore.firestore().collection("material").getDocuments()
        
            let material = snapshot.documents.compactMap { doc in
                try? doc.data(as: Material.self)
            }
            return material
    }
    
    
    //Uppdatera post
    func updateMaterialPost(material: Material) throws{
        
        try? materialDocuments(material: material).setData(from: material, merge: true)
    }
    
    
    //Delete post
    func deleteMaterialPost(materialPost: Material)async throws{
        
        print("run delete material \(materialPost.id)")
        try await materialColletion.document(materialPost.id).delete()
        
        
    }
    
    
}

