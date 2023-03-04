//
//  DetailViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseFirestore


final class DetailViewModel: ObservableObject {
    @Published var store: Store
    @Published var isLiked: Bool = false
    
    private let database = Firestore.firestore()
    
    init(store: Store) {
        self.store = store
        checkIsLikedStore(store)
        
    }
    
    //MARK: - initalizing 할 때 User/LikedStore 컬렉션에 해당 가게가 있는지 체크
    
    private func checkIsLikedStore(_ store: Store) {
        guard let documentId = store.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.collection("User")
            .document(uid)
            .collection("LikedStore")
            .document(documentId)
            .getDocument { (document, error) in
                if let document {
                    self.isLiked = document.exists
                }
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
            }
    }
    
    private func dislikeStore() {
        guard let documentId = store.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.collection("User")
            .document(uid)
            .collection("LikedStore")
            .document(documentId)
            .delete { error in
                if let error {
                    print(#function, error.localizedDescription)
                    return
                }
                
                self.database.collection("Store")
                    .document(documentId)
                    .updateData(["likes": self.store.likes - 1])
            }
    }
    
    
    private func likeStore()  {
        guard let documentId = self.store.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let _ = try database.collection("User")
                .document(uid)
                .collection("LikedStore")
                .addDocument(from: self.store) { error in
                    if let error {
                        print(#function, error.localizedDescription)
                        return
                    }
                    self.database.collection("Store")
                        .document(documentId)
                        .updateData(["likes": self.store.likes + 1])
                }
        } catch {
            
        }
    }
    
    //MARK: - UI 핸들러
    
    func handleLikeButton()  {
        self.isLiked.toggle()
        if isLiked {
             likeStore()
        } else {
             dislikeStore()
        }
    }
    
}
