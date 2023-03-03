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
    
    
    // MARK: - 찜한 가게 추가/삭제
//    func manageHeart(userId: String, store: Store) {
//        let ref = database.collection("User").document(userId).collection("LikedStore").document(store.id ?? "")
//        
//        if isHeart {
//            ref.setData([
//                "storeId" : store.id ?? "",
//                "storeName" : store.storeName,
//                "storeAddress" : store.storeAddress,
//                "coordinate" : store.coordinate,
//                "storeImages" : store.storeImages,
//                "description" : store.description,
//                "countingStar" : store.countingStar
//            ])
//            print("\(self.isHeart)")
//            print("\(#function) : 찜한 가게 추가")
//            self.likeStore(userId: userId, store: store)
//        } else {
//            ref.delete()
//            print("\(self.isHeart)")
//            print("\(#function) : 찜한 가게 삭제")
//            self.disLikeStore(userId: userId, store: store)
//
//        }
//        self.fetchLikedStore()
//    }
    
    func likeStore(userId: String, store: Store){
        let ref = database.collection("Store").document(store.id ?? "")
        ref.updateData([
            "likes": store.likes + 1])
    }
    func disLikeStore(userId: String, store: Store){
        let ref = database.collection("Store").document(store.id ?? "")
        ref.updateData([
            "likes": store.likes - 1])
    }


} 
