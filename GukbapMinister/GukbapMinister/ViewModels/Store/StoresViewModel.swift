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
    //FIXME: collectionViewModel로 옮길것!!!
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
                        
                        //FIXME: Kingfisher 도입하면 fetchImage 메서드가 더이상 필요 없을 예정
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
    
    
    
    
    func fetchImages(storeId: String, imageName: String) async throws -> UIImage {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")

        let data = try await ref.data(maxSize: 1 * 1024 * 1024)
        let image = UIImage(data: data)
        
        self.storeTitleImage[imageName] = image
        
        return image!
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



