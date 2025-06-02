//
//  MaterialManger.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import Foundation
import FirebaseFirestore

final class MaterialManager {
    
    static let shared = MaterialManager()
    private init() {}
    
    private let materialColletion = Firestore.firestore().collection("material")
    
    func materialDocuments(material: MaterialList) -> DocumentReference {
        return materialColletion.document(material.id)
    }
    
    //Ny post med förbruknings material
    func writeNewMaterialPost(material: MaterialList)async throws{
        try materialDocuments(material: material).setData(from: material, merge: false)
    }
    
    //hämta allt material
    func readMaterialList() async throws -> [MaterialList] {
        
        let snapshot = try await Firestore.firestore().collection("material").getDocuments()
        
            let material = snapshot.documents.compactMap { doc in
                try? doc.data(as: MaterialList.self)
            }
            return material
    }
    
    //radera post med material
    func deleteMaterialPost(materialPost: MaterialList)async throws{
        
        try await materialColletion.document(materialPost.id).delete()
        
        
    }
    
    
}
