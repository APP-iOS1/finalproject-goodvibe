//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation
import UIKit

import Firebase
import FirebaseFirestore
import FirebaseStorage

// 스토어의 정보를 모두 가져오는 뷰모델
final class StoresViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var storeTitleImage: [String : UIImage] = [:]
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    private var listenerRegistration: ListenerRegistration?
    
    //Store정보 구독취소
    //Store정보가 필요한 뷰에서
    //.onDisappear { viewModel.unsubscribeStores() } 하면 실행됨
    func unsubscribeStores() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    //Store정보 구독
    //Store정보가 필요한 뷰에서
    //.onAppear { viewModel.subscribeStores() } 하면 실행됨
    func subscribeStores() {
        if listenerRegistration == nil {
            listenerRegistration =  database.collection("Store")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    
                    //FirebaseFireStoreSwift 를 써서 @Document 프로퍼티를 썼더니 가능
                    self.stores = documents.compactMap { queryDocumentSnapshot in

                        let result = Result { try queryDocumentSnapshot.data(as: Store.self) }

                        switch result {
                        case .success(let store):
                            for imageName in store.storeImages {
                                self.fetchImages(storeId: store.storeName, imageName: imageName)
                            }
                            return store
                        case .failure(let error):
                            print(#function, "\(error.localizedDescription)")
                            return nil
                        }
                    }
                }
        }
    }
    
    
    // MARK: - Storage에서 이미지 다운로드
    private func fetchImages(storeId: String, imageName: String) {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.storeTitleImage[imageName] = image
                
            }
        }
    }
}
