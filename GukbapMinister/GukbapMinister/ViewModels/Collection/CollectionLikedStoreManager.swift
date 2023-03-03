//
//  CollectionLikedStoreManager.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class CollectionLikedStoreManager: ObservableObject {
    @Published var store: Store
    
    private var database = Firestore.firestore()
    
    init(store: Store = .test) {
        self.store = store
    }
    

    func dislikeStore() async {
        if let documentId = self.store.id,
           let uid = Auth.auth().currentUser?.uid {
            do {
                try await database.collection("User")
                    .document(uid)
                    .collection("LikedStore")
                    .document(documentId)
                    .delete()
                
                try await database.collection("Store")
                    .document(documentId)
                    .updateData(["likes": self.store.likes - 1])
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
