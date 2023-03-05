//
//  CollectionViewModel.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/30.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CollectionViewModel : ObservableObject {
    @Published var stores: [Store] = []

    private let database = Firestore.firestore()
    private let storage = Storage.storage()
    private var listenerRegistration: ListenerRegistration?
    
    // MARK: - 찜한 가게 목록 listener 해제
    func unsubscribeLikedStores() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    // MARK: - 찜한 가게 목록 listener
    func subscribeLikedStore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if listenerRegistration == nil {
            listenerRegistration =
            database
                .collection("User")
                .document(uid)
                .collection("LikedStore")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    
                    self.stores = documents.compactMap { queryDocumentSnapshot in
                      try? queryDocumentSnapshot.data(as: Store.self)
                    }
                }
        }
    }

} 
