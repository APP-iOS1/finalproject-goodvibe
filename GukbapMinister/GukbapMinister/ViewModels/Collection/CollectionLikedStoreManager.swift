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

//FIXME: 만들고보니까 DetailViewModel이랑 중복되는 코드가 많아서 추후 수정하면 좋을 것 같다.
final class CollectionLikedStoreManager: ObservableObject {
    @Published var store: Store
    
    private var database = Firestore.firestore()
    
    init(store: Store = .test) {
        self.store = store
    }
    
    
    func dislikeStore() async {
        guard let documentId = store.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
    
    private func likeStore() async {
        guard let documentId = self.store.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await database.collection("Store")
                .document(documentId)
                .updateData(["likes": self.store.likes + 1])
            
            let _ = try database.collection("User")
                .document(uid)
                .collection("LikedStore")
                .addDocument(from: self.store)
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
}
