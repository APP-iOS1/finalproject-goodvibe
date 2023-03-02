//
//  ExploreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

final class ExploreViewModel: ObservableObject {
    @Published var stores: [Store] = [] {
        willSet(newValue) {
            orderStoreByHits(stores: newValue)
            orderStoreByStars(stores: newValue)
            getImageUrls(stores: newValue)
        }
    }
    @Published var storesOrderedByStar: [Store] = []
    @Published var storesOrderedByHits: [Store] = []
    
    /// [storeName : 이미지URL배열]
    @Published var storeImageURLs: [String: [URL]] = [:]
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    
    init(stores: [Store]) {
        self.stores = stores
    }
    
    ///Store를 별점순으로 정렬
    private func orderStoreByStars(stores: [Store]) {
        self.storesOrderedByStar = stores.sorted { $0.countingStar > $1.countingStar }
    }
    
    ///Store를 조회수순으로 정렬
    private func orderStoreByHits(stores: [Store]) {
        self.storesOrderedByHits = stores.sorted { $0.hits > $1.hits }
    }
    
    ///stores 배열을 순회하며 Storage에서 이미지 URL을 받아온다.
    private func getImageUrls(stores: [Store]) {
        for store in stores {
            self.storeImageURLs[store.storeName] = []
            storage.reference().child("storeImages/\(store.storeName)").listAll { result, error in
                if let error {
                    print(#function, error.localizedDescription)
                }
                
                if let result {
                    for ref in result.items {
                        ref.downloadURL { url, error in
                            if let error {
                                print(#function, error.localizedDescription)
                            }
                            
                            if let url {
                                self.storeImageURLs[store.storeName]?.append(url)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 조회수를 increase시키는 메서드 
    func increaseHits(store : Store) {
        if let documentId = store.id {
            database.collection("Store")
                    .document(documentId)
                    .updateData(["hits" : store.hits + 1])

        }
    }
    
    
}
