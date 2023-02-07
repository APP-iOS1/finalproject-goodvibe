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
@MainActor
final class StoresViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var storeTitleImage: [String : UIImage] = [:]
    @Published var countRan = 0

    
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
    
    // 생성 시점 이슈로 인해 뷰모델에서 난수를 생성
    func getRandomNumber() {
        database.collection("Store").getDocuments()
        {
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                var count = 0
                for document in querySnapshot!.documents {
                    count += 1
                    print("\(document.documentID) => \(document.data())");
                }
                self.countRan = Int.random(in: 0..<count)
            }
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
                                Task.init{
                                    do{
                                        try await self.fetchImages(storeId: store.storeName, imageName: imageName)
                                    }
                                    catch{
                                        
                                    }
                                }
                               
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
//    private func fetchImages(storeId: String, imageName: String) {
//        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
//            if let error = error {
//                print("error while downloading image\n\(error.localizedDescription)")
//                return
//            } else {
//                let image = UIImage(data: data!)
//                self.storeTitleImage[imageName] = image
//
//            }
//        }
//    }
    func fetchImages(storeId: String, imageName: String) async throws -> UIImage {
        print("스토어 아이디: \(storeId)")
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")

        let data = try await ref.data(maxSize: 1 * 1024 * 1024)
        let image = UIImage(data: data)
        
        self.storeTitleImage[imageName] = image
        
        return image!
    }
}


