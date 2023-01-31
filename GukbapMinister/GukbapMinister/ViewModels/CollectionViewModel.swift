//
//  CollectionViewModel.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/30.
//

import Foundation
import FirebaseFirestore
import Firebase
import UIKit
import CoreLocation
import MapKit
import FirebaseStorage

class CollectionViewModel : ObservableObject {
    
    // 하트를 눌렀을때 현재 사용자 document에 LikedStore 컬렉션에 storeid 추가
    // 필요한 것 : 현재사용자의 id
    @Published var isHeart: Bool = false
    @Published var stores: [Store] = []
    @Published var storeImages: [String : UIImage] = [:] 
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    // MARK: - 찜한 가게 목록 불러오기
    func fetchLikedStore(userId: String) {
        print("userID : \(userId)")
        let ref = database.collection("User").document("\(userId)").collection("LikedStore")
        
        ref.getDocuments { snapShot, error in
            
            self.stores.removeAll()
            
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
                    
                    print("\(#function) : \(storeName) \\\\ \(storeImages)")
                    
                    for imageName in storeImages {
                        self.fetchImages(storeId: storeName, imageName: imageName)
                    }
                    
                    let store: Store = Store(id: id,
                                             storeName: storeName,
                                             storeAddress: storeAddress,
                                             coordinate: coordinate,
                                             storeImages: storeImages,
                                             menu: menu,
                                             description: description,
                                             countingStar: countingStar)
                    
                    self.stores.append(store)
                }
            }
        }
    }
    
    // MARK: - 찜한 가게 삭제 후 갱신
    func removeLikedStore(userId: String, store: Store) {
        let ref = database.collection("User").document(userId).collection("LikedStore").document(store.id ?? "")
        
        ref.delete()
        
        self.fetchLikedStore(userId: userId)
    }
    
    // MARK: - 찜한 가게 추가/삭제
    func manageHeart(userId: String, store: Store) {
        print("\(#function) : \(userId)")
        let ref = database.collection("User").document(userId).collection("LikedStore").document(store.id ?? "")
        
        if isHeart {
            ref.setData([
                "storeId" : store.id,
                "storeName" : store.storeName,
                "storeAddress" : store.storeAddress,
                "coordinate" : store.coordinate,
                "storeImages" : store.storeImages,
                "description" : store.description,
                "countingStar" : store.countingStar
            ])
            print("\(self.isHeart)")
            print("\(#function) : 찜한 가게 추가")
        } else {
            ref.delete()
            print("\(self.isHeart)")
            print("\(#function) : 찜한 가게 삭제")
        }
    }
    
    // MARK: - Storage에서 이미지 다운로드
    func fetchImages(storeId: String, imageName: String) {
        print("이미지 패치 함수 실행됨")
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.storeImages[imageName] = image
                print("\(#function) : \(self.storeImages)")
            }
        }
    }
}
