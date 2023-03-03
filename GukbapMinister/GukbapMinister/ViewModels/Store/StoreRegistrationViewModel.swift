//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

import Firebase
import FirebaseFirestore
import FirebaseStorage

final class StoreRegistrationViewModel: ObservableObject {
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
                              foodType: ["순대국밥"],
                              likes: 0,
                              hits: 0
    )) {

        self.store = store
        self.$store
            .dropFirst()
            .sink { [weak self] store in
                self?.modified = true
            }
            .store(in: &self.cancellables)
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
//    func fetchImages(storeId: String, imageName: String) {
//        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")
//
//        ref.getData(maxSize: 15 * 1024 * 1024) { [self] data, error in
//            if let error = error {
//                print("error while downloading image\n\(error.localizedDescription)")
//                return
//            } else {
//                let image = UIImage(data: data!)
//                self.storeImages[imageName] = image
//
//            }
//        }
//    }
    
    func fetchImages(storeId: String, imageName: String) async throws -> UIImage {
        let ref = storage.reference().child("storeImages/\(storeId)/\(imageName)")

        let data = try await ref.data(maxSize: 1 * 1024 * 1024)
        let image = UIImage(data: data)
        
        self.storeImages[imageName] = image
        
        return image!
    }

        // MARK: - UI 핸들러
    
    func handleDoneTapped() {
        self.updateOrAddStoreInfo()
    }
    
    func handleDeleteTapped() {
        self.removeStoreInfo()
    }
    
 
}//StoreViewModel
