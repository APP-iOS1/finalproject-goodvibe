//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import Combine
import SwiftUI
import PhotosUI

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Foundation

final class StoreViewModel: ObservableObject {
    @Published var store: Store
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
    @Published var selectedImages: [PhotosPickerItem] = []
    @Published var selectedImageData: [Data] =  []
    @Published var convertedImages: [UIImage] =  []
    
    @Published var stores: [Store] = []
    @Published var storeImages: [String : UIImage] = [:]
    
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    
    
    init(store: Store = Store(storeName: "",
                              storeAddress: "",
                              coordinate: GeoPoint(latitude: 0, longitude: 0),
                              storeImages: [],
                              menu: [:],
                              description: "",
                              countingStar: 0.0,
                              foodType: ["순대국밥"]
    )) {

        self.store = store
        self.$store
            .dropFirst()
            .sink { [weak self] store in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - 가게 목록 불러오기
    func fetchStore() {
       database.collection("Store")
            .getDocuments { snapShot, error in
            
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
                                             countingStar: countingStar,
                                             foodType: ["순대국밥"])

                    self.stores.append(store)
                }
            }
        }
    }
    
    private func convertToUIImages() {
        if !selectedImageData.isEmpty {
            for imageData in selectedImageData {
                if let image = UIImage(data: imageData) {
                    convertedImages.append(image)
                }
            }
        }
    }
    
    private func makeImageName() -> [String] {
        var imgNameList: [String] = []
        
        // iterate over images
        for img in convertedImages {
            let imgName = UUID().uuidString
            imgNameList.append(imgName)
            uploadImage(image: img, name: (store.storeName + "/" + imgName))
        }
        return imgNameList
    }
    
    
    private func addStoreInfo() {
        do {
            self.convertToUIImages()
            self.store.storeImages = makeImageName()
            //위도 경도값을 형변환해서 넣어주기
            self.store.coordinate = GeoPoint(latitude: Double(self.latitude) ?? 0.0, longitude: Double(self.longitude) ?? 0.0)
            
            let _ = try database.collection("Store")
                .addDocument(from: self.store)
        }
        catch {
            print(error)
        }
    }
    
    private func updateStoreInfo(_ store: Store) {
        
        if let documentId = store.id {
            do {
                try database.collection("Store")
                    .document(documentId)
                    .setData(from: store)
            }
            catch {
                print(error)
            }
            
        }
    }
    
    
    private func removeStoreInfo() {
        if let documentId = self.store.id {
            database.collection("Store").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    private func updateOrAddStoreInfo() {
        if let _ = store.id {
            self.updateStoreInfo(self.store)
        }
        else {
            addStoreInfo()
        }
    }
    
    private func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("storeImages/\(name)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
        
    }
    // MARK: - Storage에서 이미지 다운로드
    func fetchImages(storeId: String, imageName: String) {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.storeImages[imageName] = image
         
            }
        }
    }
    
        // MARK: - UI 핸들러
    
    func handleDoneTapped() {
        self.updateOrAddStoreInfo()
    }
    
    func handleDeleteTapped() {
        self.removeStoreInfo()
    }
    
 
}//StoreViewModel
