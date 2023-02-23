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
    
    @Published var storesStar: [Store] = []
    @Published var storeTitleImageStar: [String : UIImage] = [:]
    
    @Published var countRan = 0

    @Published var storesHits: [Store] = []
    @Published var storeTitleImageHits: [String : UIImage] = [:]
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    private var listenerRegistration: ListenerRegistration?
    
    
    
    func fetchStarStores() {
            let ref = database.collection("Store").order(by: "countingStar", descending: true)
            
            ref.getDocuments { snapShot, error in
                
                self.storesStar.removeAll()
                
                if let snapShot {
                    for document in snapShot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let storeName: String = docData["storeName"] as? String ?? ""
                        let storeAddress: String = docData["storeAddress"] as? String ?? ""
                        let coordinate: GeoPoint = docData["coordinate"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
                        let storeImages: [String] = docData["storeImages"] as? [String] ?? []
                        let menu: [String : String] = docData["menu"] as? [String : String] ?? ["":""]
                        let description: String = docData["description"] as? String ?? ""
                        let countingStar: Double = docData["countingStar"] as? Double ?? 0
                        let foodType : [String] = docData["foodType"]  as? [String] ?? []
                        let likes : Int = docData["likes"]  as? Int ?? 0
                        let hits : Int = docData["hits"] as? Int ?? 0


                        for imageName in storeImages {
                            self.fetchImagesStar(storeId: storeName, imageName: imageName)
                        }

                        let store: Store = Store(id: id,
                                                 storeName: storeName,
                                                 storeAddress: storeAddress,
                                                 coordinate: coordinate,
                                                 storeImages: storeImages,
                                                 menu: menu,
                                                 description: description,
                                                 countingStar: countingStar,
                                                 foodType: foodType,
                                                 likes: likes,
                                                 hits: hits)
                         
                        
                        self.storesStar.append(store)
                    }
                }
            }
    }
    
    
    
    func fetchHitsStores() {
            let ref = database.collection("Store").order(by: "hits", descending: true)

            ref.getDocuments { snapShot, error in

                self.storesHits.removeAll()

                if let snapShot {
                    for document in snapShot.documents {
                        let id: String = document.documentID
                        let docData = document.data()

                        let storeName: String = docData["storeName"] as? String ?? ""
                        let storeAddress: String = docData["storeAddress"] as? String ?? ""
                        let coordinate: GeoPoint = docData["coordinate"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
                        let storeImages: [String] = docData["storeImages"] as? [String] ?? []
                        let menu: [String : String] = docData["menu"] as? [String : String] ?? ["":""]
                        let description: String = docData["description"] as? String ?? ""
                        let countingStar: Double = docData["countingStar"] as? Double ?? 0
                        let foodType : [String] = docData["foodType"]  as? [String] ?? []
                        let likes : Int = docData["likes"]  as? Int ?? 0
                        let hits : Int = docData["hits"] as? Int ?? 0

                        for imageName in storeImages {
                            self.fetchImagesHits(storeId: storeName, imageName: imageName)
                        }

                        let store: Store = Store(id: id,
                                                 storeName: storeName,
                                                 storeAddress: storeAddress,
                                                 coordinate: coordinate,
                                                 storeImages: storeImages,
                                                 menu: menu,
                                                 description: description,
                                                 countingStar: countingStar,
                                                 foodType: foodType,
                                                 likes: likes,
                                                 hits: hits)

                        self.storesHits.append(store)
                    }
                }
            }
    }


    // 조회수를 increase시키는 메서드 (onAppear시 동작)
    func increaseHits(store : Store) {
        var updateStoreHits = store
        updateStoreHits.hits += 1

        if let documentId = store.id {
            do {
                try database.collection("Store")
                    .document(documentId)
                    .updateData(["hits" : updateStoreHits.hits])
            }
            catch {
                print(error)
            }
        }
    }
    
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
                                        print("sotreViewModel 'fetchImages' Error")
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
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")

        let data = try await ref.data(maxSize: 1 * 1024 * 1024)
        let image = UIImage(data: data)
        
        self.storeTitleImage[imageName] = image
        
        return image!
    }
    
    
    func fetchImagesStar(storeId: String, imageName: String) {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.storeTitleImageStar[imageName] = image
         
            }
        }
    }
    
    func fetchImagesHits(storeId: String, imageName: String) {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.storeTitleImageHits[imageName] = image

            }
        }
    }
    
//    // MARK: 사용자 찜하기 데이터 수정 Method
//    func fetchFavorite(isFavorited: Bool, user: User, storeId: String) async {
//        let deleteStore = user.favoriteStoreId.filter { $0 != storeId}
//
//        do{
//            if isFavorited {
//                try await database.collection("User")
//                    .document(user.id)
//                    .updateData([
//                        "favoriteId": deleteStore + [storeId]
//                    ])
//            }else {
//                try await database.collection("User")
//                    .document(user.id)
//                    .updateData([
//                        "favoriteId": deleteStore
//                    ])
//            }
//        }catch{
//            print("fetchFavoriteStore error: \(error.localizedDescription)")
//        }
//    }
//
//    // MARK: Store 좋아요 불러오는 Method
//    func fetchUserFavoriteFoodCart(userId: String, foodCartId: String) async throws -> Bool {
//        var user: User // 비동기 통신으로 받아올 Property
//
//        let userSnapshot = try await database.collection("User").document(userId).getDocument() // 첫번째 비동기 통신
//        let docData = userSnapshot.data()!
//
//        let id: String = docData["id"] as? String ?? ""
//        let email: String = dataDescription?["userEmail"] as? String ?? ""
//        let nickName: String = dataDescription?["userNickname"] as? String ?? ""
//        let ageRange: Int = dataDescription?["userEmail"] as? Int ?? 2
//        let gukbaps: [String] = dataDescription?["gukbaps"] as? [String] ?? []
//        let preferenceArea: String = dataDescription?["preferenceArea"] as? String ?? ""
//        let status : String = dataDescription?["status"] as? String ?? ""
//        let reviewCount: Int = dataDescription?["reviewCount"] as? Int ?? 0
//        let storeReportCount: Int = dataDescription?["storeReportCount"] as? Int ?? 0
//
//
//
//        user = User(id: id, userNickname: userNickName, userEmail: userEmail, preferenceArea: preferenceArea, gender: gender, ageRange: ageRange, gukbaps: [gukbaps], filterdGukbaps: [filterdGukbaps], status: status, reviewCount: reviewCount, storeReportCount: storeReportCount, favoriteStoreId: [FavoriteStoreId])
//
//        return user.favoriteId.contains(StoreId)
//    }
    
}



