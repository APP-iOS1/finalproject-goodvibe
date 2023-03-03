//
//  StoreImageManager.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import Foundation
import FirebaseStorage

final class StoreImageManager: ObservableObject {
    @Published var store: Store = .test {
        willSet(newValue) {
            getImageURLs(newValue)
        }
    }
    @Published var imageURLs: [URL] = []
    private var storage = Storage.storage()
    
    init(store: Store) {
        self.store = store
    }
    
    
    func getImageURLs(_ store: Store) {
        storage.reference().child("storeImages/\(store.storeName)").listAll { result, error in
            if let error {
                print(error.localizedDescription)
            }
            if let result {
                for ref in result.items {
                    ref.downloadURL { url, error in
                        if let error {
                            print( error.localizedDescription)
                        }
                        if let url {
                            self.imageURLs.append(url)
                        }
                    }
                }
            }
        }
    }
    
}
